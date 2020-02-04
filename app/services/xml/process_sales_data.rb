class Xml::ProcessSalesData
  BASE_PATH = Rails.root.join('files_to_process').to_s

  def execute(custom_path: nil, move_processed_file: true)
    files = Dir.glob('*.xml', base: BASE_PATH) # array of XML files to process
    files.each do |file|
      file_path = custom_path ? custom_path : BASE_PATH + '/' + file
      File.open(file_path) { |f| Nokogiri::XML(f) }

      sales_data = File.open(file_path) { |f| Nokogiri::XML(f) }.to_s
      sales_data = Hash.from_xml(sales_data)['Root']

      ActiveRecord::Base.transaction do
        batch = new_batch(sales_data)
        new_invoices(sales_data, batch)

        batch.save
      end

      FileUtils.mv(file_path, BASE_PATH + '/processed/' + file) if move_processed_file
    end
    [true, 'Success']
  rescue StandardError => e
    [false, e.to_s + e.backtrace.join('\n')]
  end

  private

  def new_batch(sales_data)
    Batch.new(
      sales_batch_id: sales_data['FileData']['Batch']['BatchID'],
      creation_date: sales_data['FileData']['Batch']['CreationDate'],
      file_guid: sales_data['FileAttribute']['GUID']
    )
  end

  def new_invoices(sales_data, batch)
    invoice_operation = sales_data['FileData']['Invoice']
    if invoice_operation.is_a?(Array) # file may have one or several invoices
      invoice_operation.each_with_index do |operation, index|
        batch.invoices.build
        invoice = batch.invoices[index]
        invoice.company_id = operation['InvoiceOperation']['CompanyCode'].to_i
        invoice.operation_number = operation['InvoiceOperation']['InvoiceOperationNumber'].to_i
        invoice.operation_date = operation['InvoiceOperation']['InvoiceOperationDate']

        new_invoice_parcels(operation, batch.invoices[index])
      end
    else
      batch.invoices.build
      invoice = batch.invoices.first
      invoice.company_id = invoice_operation['InvoiceOperation']['CompanyCode'].to_i
      invoice.operation_number = invoice_operation['InvoiceOperation']['InvoiceOperationNumber'].to_i
      invoice.operation_date = invoice_operation['InvoiceOperation']['InvoiceOperationDate']

      new_invoice_parcels(invoice_operation, batch.invoices.first)
    end
  end

  def new_invoice_parcels(invoice_operation, invoice)
    invoice_data = invoice_operation['InvoiceData']
    if invoice_data.is_a?(Array) # invoice may have one or several parcels
      invoice_data.each_with_index do |data, index|
        invoice.parcels.build
        parcel = invoice.parcels[index]
        parcel.quantity = data['ItemQty'].to_i
        parcel.price = data['ParcelPrice'].to_f
        parcel.parcel_code = data['ParcelCode']
      end
    else
      invoice.parcels.build
      parcel = invoice.parcels.first
      parcel.quantity = invoice_data['ItemQty'].to_i
      parcel.price = invoice_data['ParcelPrice'].to_f
      parcel.parcel_code = invoice_data['ParcelCode']
    end
  end
end

#{"FileAttribute"=>
#  {"GUID"=>"16BA036FCC3D4AF7E05378A06D0ADD38"},
#"FileData"=>
#  {"Batch"=>{"BatchID"=>"844986", "CreationDate"=>"21.05.2015"},
#  "Invoice"=>
#    [
#      {"InvoiceOperation"=>
#        {"CompanyCode"=>"1234", "InvoiceOperationNumber"=>"45734328", "InvoiceOperationDate"=>"21.05.2015"},
#      "InvoiceData"=>{"ParcelCode"=>"114211372050132", "ItemQty"=>"1", "ParcelPrice"=>"3493"}},
#      {"InvoiceOperation"=>
#        {"CompanyCode"=>"1234", "InvoiceOperationNumber"=>"45733790", "InvoiceOperationDate"=>"21.05.2015"},
#      "InvoiceData"=>[
#                       {"ParcelCode"=>"114180267042132", "ItemQty"=>"1", "ParcelPrice"=>"3493"},
#                       {"ParcelCode"=>"114207400042141", "ItemQty"=>"1", "ParcelPrice"=>"6293"}
#                     ]
#      }
#    ]
#  }
#}
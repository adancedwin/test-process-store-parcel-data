require 'rails_helper'

describe Xml::ProcessSalesData do
  context 'positive tests' do
    context 'valid xml file' do
      it 'should create a new record and return array with true' do
        result = Xml::ProcessSalesData.new.execute(
                                  custom_path: Rails.root.join('spec', 'support', 'files_to_process', 'test_sales_data.xml').to_s,
                                  move_processed_file: false
                                )
        result = result.first

        expect(Batch.all.count).to eq(1)
        expect(result).to eq(true)
      end
    end
  end

  context 'negative tests' do
    it 'should not create a second record in db' do
      Xml::ProcessSalesData.new.execute(
          custom_path: Rails.root.join('spec', 'support', 'files_to_process', 'test_sales_data.xml').to_s,
          move_processed_file: false
      )

      expect(Batch.all.count).to eq(1)
    end
  end
end
class BatchesController < ApplicationController
  def new; end

  def create
    result = Xml::ProcessSalesData.new.execute
    if result.first
      render :new, locals: { message: 'Success' }
    else
      render :new, locals: { message: result.last }
    end
  end
end
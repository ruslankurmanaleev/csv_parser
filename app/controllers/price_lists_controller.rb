class PriceListsController < ApplicationController
  def new
  end

  def create
    request = PriceList.new(fetch_name_from_params, fetch_path_from_params, fetch_params).parse

    if request.dig(:status) == true
      redirect_to(root_path, notice: request[:message])
    else
      redirect_to(root_path, alert: request[:message])
    end
  end

  private

  def fetch_path_from_params
    params.dig(:price_list, :attachments).first.tempfile.to_path
  end

  def fetch_name_from_params
    params.dig(:price_list, :name)
  end

  def fetch_params
    {
      brand: params.dig(:price_list, :header_brand),
      code: params.dig(:price_list, :header_code),
      stock: params.dig(:price_list, :header_stock),
      cost: params.dig(:price_list, :header_cost),
      name: params.dig(:price_list, :header_name),
      delimeter: params.dig(:price_list, :delimeter),
      encoding: params.dig(:price_list, :encoding)
    }
  end
end

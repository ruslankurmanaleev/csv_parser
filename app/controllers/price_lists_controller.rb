class PriceListsController < ApplicationController
  def new
  end

  def create
    request = PriceList.new(fetch_name_from_params, fetch_path_from_params).parse

    if request
      redirect_to(root_path, notice: "Файл обработан. Обновлено и создано #{request} записей соответственно")
    else
      render :new
    end
  end

  private

  def fetch_path_from_params
    params.dig(:price_list, :attachments).first.tempfile.to_path
  end

  def fetch_name_from_params
    params.dig(:price_list, :name)
  end
end

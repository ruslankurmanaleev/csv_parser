require "rails_helper"

RSpec.feature "User processes the new Price List" do
  let(:price_list) { file_fixture("price_list1.csv") }
  let(:price_list2) { file_fixture("price_list2.csv") }
  let(:price_list3) { file_fixture("price_list3.csv") }

  before { visit new_price_list_path }

  def fill_in_default_form
    fill_in(:price_list_name, with: "price_list1")
    attach_file(:price_list_attachments, price_list)
    click_on "Обработать"
  end

  def fill_in_complex_form
    fill_in(:price_list_name, with: "price_list2")
    attach_file(:price_list_attachments, price_list2)
    fill_in(:price_list_header_stock, with: "Количество")
    fill_in(:price_list_header_code, with: "Артикул")
    fill_in(:price_list_encoding, with: "UTF-8")
    fill_in(:price_list_delimeter, with: ",")
    click_on "Обработать"
  end

  def fill_in_complex_form2
    fill_in(:price_list_name, with: "price_list3")
    attach_file(:price_list_attachments, price_list3)
    fill_in(:price_list_header_code, with: "Артикул")
    fill_in(:price_list_header_brand, with: "Бренд")
    fill_in(:price_list_header_name, with: "НаименованиеТовара")
    fill_in(:price_list_header_stock, with: "Количество")
    fill_in(:price_list_header_cost, with: "Цена")
    fill_in(:price_list_encoding, with: "UTF-8")
    fill_in(:price_list_delimeter, with: ";")
    click_on "Обработать"
  end

  context "when csv params are default" do
    it "uploads the PriceList of 9 valid and 0 invalid records" do
      fill_in_default_form

      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Файл обработан. Обновлено и создано 0, 9 записей соответственно")
      expect(Product.count).to eq 9
    end
  end

  context "when csv params are different" do
    it "uploads the PriceList of 10 valid and 0 invalid records" do
      fill_in_complex_form()

      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Файл обработан. Обновлено и создано 0, 10 записей соответственно")
      expect(Product.count).to eq 10
    end
  end

  context "when csv params are different" do
    it "uploads the PriceList of 10 valid and 2 invalid records" do
      fill_in_complex_form2

      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Файл обработан. Обновлено и создано 0, 10 записей соответственно")
      expect(Product.count).to eq 10
    end
  end
end

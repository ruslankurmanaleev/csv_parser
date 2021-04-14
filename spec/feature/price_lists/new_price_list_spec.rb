require "rails_helper"

RSpec.feature "User processes the new Price List" do
  let(:price_list) { file_fixture("price_list1.csv") }

  before { DatabaseCleaner.clean }

  context "when PriceList is valid" do
    it "uploads the PriceList of 9 valid and 1 invalid records" do
      visit new_price_list_path

      fill_in(:price_list_name, with: "price_list1")
      attach_file(:price_list_attachments, price_list)
      click_on "Обработать"

      expect(page).to have_current_path(root_path)
      expect(page).to have_content("Файл обработан. Обновлено и создано 0, 9 записей соответственно")
      expect(Product.count).to eq 9
    end
  end
end

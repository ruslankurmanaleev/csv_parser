require "csv"

class PriceList
  # Change encoding and delimiter if required
  ENCODING = "windows-1251".freeze
  DELIMITER = ";".freeze

  def initialize(name, file, header_params)
    @pricelist = name
    @file_path = file
    @header_params = header_params
    @skipped_counter = 0
    @created_counter = 0
  end

  def parse
    build_headers
    # We need to clean all existing data with the same PriceList name
    erase_price_list_if_exists!

    # With each line of CSV file parse product with headers, so we can have a Hash later
    CSV.foreach(@file_path, col_sep: DELIMITER, row_sep: :auto, headers: true, nil_value: nil, quote_char: "|", encoding: ENCODING) do |product|
      # It's easier and more explicit to work with Hash here instead of Array
      product = product.to_hash

      # Skip lines with blank params
      next if blank_params?(product)

      # Update stock for the product if it's required
      product[@stock] = format_stock(product[@stock]) if need_to_format_stock?(product[@stock])

      # Find existing Product with UID
      existing_product = fetch_existing_product_or_nil(product)

      next update_product!(existing_product, product) unless existing_product.nil?

      create_product!(product)
    end

    "#{@skipped_counter}, #{@created_counter}"
  end

  private

  def build_headers
    @brand = @header_params[:brand]
    @code = @header_params[:code]
    @stock = @header_params[:stock]
    @cost = @header_params[:cost]
    @name = @header_params[:name]
  end

  # Destroys object by given pattern one by one
  def erase_price_list_if_exists!
    Product.where(price_list: @pricelist).each { |list| list.destroy }
  end

  # If any of these params are nil, then skip the product
  def blank_params?(obj)
    obj[@brand].strip.blank? || obj[@code].blank? || obj[@name].blank? || obj[@cost].blank? || obj[@stock].blank?
  end

  # Returns nil or Product that exists, and that has to be updated
  def fetch_existing_product_or_nil(product)
    # We might have a few UIDs but with different PriceLists
    products = Product.where(uid: build_uid(product))

    return nil if products.nil?

    # If we've got the unique, return it, otherwise return nil
    products.where(price_list: @name).any? ? products.first : nil
  end

  # Updates product. Because of we have a few params, it's faster to update them all instead of parsing and updating only different
  def update_product!(existing_product, new_product_hash)
    existing_product.update(brand: new_product_hash[@brand].strip, code: new_product_hash[@code].strip,
                            stock: new_product_hash[@stock].strip,
                            name: new_product_hash[@name].strip, cost: new_product_hash[@cost].strip)

    # Add +1 to skipped counter for stats
    @skipped_counter += 1
  end

  # Creates the product
  def create_product!(product_hash)
    Product.new(brand: product_hash[@brand.strip], code: product_hash[@code].strip, stock: product_hash[@stock].strip,
                name: product_hash[@name].strip, cost: product_hash[@cost].strip,
                uid: build_uid(product_hash), price_list: @pricelist).save

    # Update this counter as well
    @created_counter += 1
  end

  # UID must be unique for one PriceList, and it must be "register-indepent", so downcase it as parsing via DB is slower
  def build_uid(product)
    "#{product[@brand]}#{product[@code]}".downcase
  end

  # If the stock has something like "> 10" (more than 10)
  def need_to_format_stock?(stock)
    stock.split.include?(">")
  end

  # If the stock has something like "> 10" (more than 10), leave just the number
  def format_stock(stock)
    stock.split.gsub(">", "").join.strip
  end
end

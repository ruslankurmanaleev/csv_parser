class AddIndexOnUidForProducts < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :uid
  end
end

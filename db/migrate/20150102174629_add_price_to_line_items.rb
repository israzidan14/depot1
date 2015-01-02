class AddPriceToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :price, :decimal, precision: 8, scale: 2

    reversible do |dir|

      dir.up do
        Product.all.each do |product|
          p product
        end
      	LineItem.all.each do |line_item|
          p line_item.product_id
      		#line_item.price = line_item.product.price
      		#line_item.save!
      	end
      end

      dir.down do
      end

    end


  end
end

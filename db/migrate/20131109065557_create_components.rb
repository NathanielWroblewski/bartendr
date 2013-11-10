class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.integer :drink_id
      t.integer :ingredient_id
      t.integer :quantity

      t.timestamps
    end
  end
end

class CreateSystemroles < ActiveRecord::Migration
  def change
    create_table :systemroles do |t|
      t.string :name, null: false
      t.integer :gid, null: false

      t.timestamps
    end
  end
end

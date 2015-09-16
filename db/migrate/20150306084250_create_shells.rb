class CreateShells < ActiveRecord::Migration
  def change
    create_table :shells do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end

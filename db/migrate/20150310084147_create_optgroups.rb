class CreateOptgroups < ActiveRecord::Migration
  def change
    create_table :optgroups do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

class CreatePuppetModules < ActiveRecord::Migration
  def change
    create_table :puppet_modules do |t|
      t.string :name
      t.string :version
      t.timestamps
    end
  end
end

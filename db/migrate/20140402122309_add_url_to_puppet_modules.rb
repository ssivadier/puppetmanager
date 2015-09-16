class AddUrlToPuppetModules < ActiveRecord::Migration
  def change
    add_column :puppet_modules, :url, :string
  end
end

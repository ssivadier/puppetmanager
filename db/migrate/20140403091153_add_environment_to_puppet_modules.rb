class AddEnvironmentToPuppetModules < ActiveRecord::Migration
  def change
    add_column :puppet_modules, :environment, :string
  end
end

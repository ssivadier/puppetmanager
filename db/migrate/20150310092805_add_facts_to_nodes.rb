class AddFactsToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :virtual, :string
    add_column :nodes, :osarch, :string
    add_column :nodes, :osfamily, :string
    add_column :nodes, :osname, :string
    add_column :nodes, :oscodename, :string
    add_column :nodes, :osversion, :string
    add_column :nodes, :kernel, :string
    add_column :nodes, :role, :string
    add_column :nodes, :profile, :string
    add_column :nodes, :environment, :string
    add_column :nodes, :description, :string
    add_column :nodes, :memorysize, :string
    add_column :nodes, :processorcount, :string
  end
end

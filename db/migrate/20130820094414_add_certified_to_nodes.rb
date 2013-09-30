class AddCertifiedToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :certified, :boolean, :default => false, :null => false
  end
end

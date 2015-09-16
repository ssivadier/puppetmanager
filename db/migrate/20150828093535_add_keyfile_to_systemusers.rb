class AddKeyfileToSystemusers < ActiveRecord::Migration
  def change
    add_column :systemusers, :keyfile, :string
  end
end

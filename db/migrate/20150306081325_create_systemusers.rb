class CreateSystemusers < ActiveRecord::Migration
  def change
    create_table :systemusers do |t|
      t.string :name, null: false
      t.integer :uid, null: false
      t.string :ensure, null: false
      t.text :comment, null: false
      t.boolean :manage_home
      t.string :password
      t.string :sshkey
      t.string :sshkeytype
      t.integer :shell_id, null: false
      t.integer :systemrole_id, null: false

      t.timestamps
    end
  end
end

class CreateJointTableOptgroupRole < ActiveRecord::Migration
  def change
    create_table :optgroups_systemroles do |t|
      t.references :optgroup, null: false
      t.references :systemrole,     null: false
    end

    # Add Index for performance de la mort qui tue !
    add_index(:optgroups_systemroles, [ :optgroup_id, :systemrole_id], :unique => true)
  end
end

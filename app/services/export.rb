# users.yml exporter
class Export
  def initialize(roles)
    @roles = roles
  end

  def call
    output = {}
    groups_hash = {}
    
    # include all roles
    @roles.each do |role|
      key = "users::#{role.name}"
      output[key] = export_role(role)
      groups_hash[role.name] = {'gid' => role.gid}
    end
    

    # uidlimit (user creation without specific uid will be above 50000)
    output["users::uidlimit"] = {'uidlimit' => { 'uid' => '50000', 'gid' => 'nogroup', 'comment' => 'uid limit', 'shell' => '/bin/false', 'managehome' => 'false'}}
    
    # Add group list for creation
    output["users::groups"] = groups_hash

    export_file = File.new(File.join(Rails.root, 'data/export.yml'), 'w')
    export_file.write output.to_yaml
    export_file.close
  end

  def export_role(role)
    role_hash = {}

    role.systemusers.each do |user|
      groups = user.systemrole.optgroups.map(&:name)

      user_hash = {
        'uid'             => user.uid,
        'gid'             => role.name,
        'ensure'          => user.ensure,
        'comment'         => user.comment,
        'shell'           => user.shell.name,
        'managehome'      => user.manage_home,
        'optional_groups' => groups
      }
      unless user.sshkey.nil? || user.sshkey.empty?
        user_hash["sshkey"] = user.sshkey
      end
      unless user.sshkeytype.nil? || user.sshkeytype.empty?
        user_hash["sshkeytype"] = user.sshkeytype
      end
      unless user.keyfile.nil? || user.keyfile.empty?
        user_hash["keyfile"] = user.keyfile
      end
      unless user.password.nil? || user.password.empty?
        user_hash["password"] = user.password
      end

      role_hash[user.name] = user_hash
    end

    role_hash
  end
end

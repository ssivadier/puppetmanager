class Import
  def initialize(data = nil)
    unless Rails.env.development?
      FileUtils.cp('/opt/puppet-secrets/hiera/users.yaml','data/users.yaml')
    end
    if data.nil?
      @yml = YAML.load_file(File.join(Rails.root, 'data/users.yaml'))
    else
      @yml = YAML.load data
    end
  end

  def call
    cleanup

    # récupérations des gids
    gids = yml.delete('users::groups')

    yml.each do |cat|
      name, users = cat
      name = name.sub('users::', '')

      # TODO ?
      next if name == 'uidlimit'

      # création du role
      role = Systemrole.create!(
        name: name,
        gid: gids[name]['gid'])

      optgroups = []

      users.each do |user|
        name, options = user

        user_ensure = options['ensure'] == 'absent' ? "absent" : "present"
        
        if options['comment'].nil?
          return name
        end
        
        # attribution des optional_groups du premier utilisateur au role
        if optgroups.empty?
          options['optional_groups'].each do |og|
            optgroups << Optgroup.find_or_create_by!(name: og)
          end
          role.optgroups = optgroups.uniq
        end

        shell_path = options['shell'] || '/bin/bash'
        shell = Shell.find_or_create_by!(name: shell_path)
        
        Systemuser.create!(
          name: name,
          uid: options['uid'].to_i,
          ensure: user_ensure,
          comment: options['comment'],
          shell: shell,
          password: options['password'],
          sshkey: options['sshkey'],
          sshkeytype: options['sshkeytype'],
          keyfile: options['keyfile'],
          manage_home: options['managehome'],
          systemrole: role,
        )
      end
    end
  end

  private

  def cleanup
    Systemuser.delete_all
    Systemrole.delete_all
    #Shell.delete_all
    Optgroup.delete_all
  end

  def yml
    @yml
  end
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
##########################
# USERS
##########################
User.delete_all

users = [
  'my.default.user@foo.bar',
]

users.each do |i|
  User.create( uid: i )
end

##########################
# SHELLS
##########################
Shell.delete_all

shells = [
    '/bin/bash',
    '/bin/zsh',
    '/bin/false'
]

shells.each do |i|
  Shell.create( name: i )
end

##########################
# OPTGROUPS
##########################
Optgroup.delete_all

optgroups = [
    'crontab',
    'www-data',
    'ssh',
    'sudo',
    'wheel',
]

optgroups.each do |i|
  Optgroup.create( name: i )
end

##########################
# ROLES
##########################
Systemrole.delete_all

Systemrole.create( name: "admin", gid: "30000" )

Systemrole.all.each do |r|
  r.optgroups = Optgroup.all
  r.save
end

##########################
#  SYSTEMUSERS
##########################

Systemuser.delete_all

Systemuser.create(
  name: "nabilla",
  uid: 30001,
  ensure: 'present',
  systemrole_id: Systemrole.first.id,
  shell_id: Shell.first.id,
  comment: "Non mais allo, quoi!",
  manage_home: 1,
  sshkey:"aaaaaaaaaaaazzzzzzzzzzzzzzz",
  sshkeytype:"rsa")

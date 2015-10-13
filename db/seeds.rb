# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
##########################
# USERS
##########################
User.delete_all

users = [
  'sebastien.sivadier@i-carre.net',
  'Herve.Pirrat@developpement-durable.gouv.fr',
  'fred.kustyan@developpement-durable.gouv.fr',
  'Tony.Fontenay@developpement-durable.gouv.fr',
  'Patrick.Bessonies@developpement-durable.gouv.fr',
  'eric.brette@developpement-durable.gouv.fr',
  'mathieu.segala@developpement-durable.gouv.fr',
  'vincent.treny@developpement-durable.gouv.fr',
  'julien.hurel@developpement-durable.gouv.fr',
  'laurent.bastet@developpement-durable.gouv.fr',
  'cedrik.mallet@i-carre.net',
  'cedric.barboiron@i-carre.net',
  'pascal.vibet@i-carre.net',
  'romaric.fernandez@i-carre.net',
  'arnaud.dallies@i-carre.net',
  'stephane.becard@i-carre.net',
  'camille.dejardin@i-carre.net'
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
    'adm',
    'crontab',
    'www-data',
    'ssh',
    'sudo',
    'j2ee',
    'wheel',
    'postgres',
    'mysql',
    'bind9',
    'postfix',
    'tomcat',
    'puppet',
    'mail',
    'libuuid',
    'exploit',
    'Debian-exim',
    'postfrop',
    'admdns',
    'nagios',
    'clamav',
    'racoon',
    'centreon',
    'ntp',
    'rundeck',
    'adminrb',
    'kvm',
    'libvirt',
    'pgbackup',
    'openldap',
    'www',
    'oldtomcat',
    'vsftp',
    'snmp',
    'snmpt',
    'ftp',
    'munin',
    'cft',
    'oracle',
    'sasl'
]

optgroups.each do |i|
  Optgroup.create( name: i )
end

##########################
# ROLES
##########################
Systemrole.delete_all

Systemrole.create( name: "admincs", gid: "30000" )

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

# README

Puppet-Manager is designed to certify or revoke puppet nodes and help you parse a user.yml file to declare system users.

Only 2 languages are available: French and English. French is the default one, but you can change the default locale in "config/
application.rb".

This application is authenticated through CAS. You can change the CAS url in "app/controllers/sessions_controller.rb"

## Installation

### The application

```sh
# Clone the repository
git clone https://github.com/ssivadier/puppetmanager.git

gem install bundler

/usr/local/bin/bundle check || /usr/local/bin/bundle install --without test --without development --without assets

RAILS_ENV=production /usr/local/bin/rake assets:clean
RAILS_ENV=production /usr/local/bin/rake assets:precompile
```

Also add to sudoers:
```sh
## BEGIN: PUPPETMANAGER SUDO
Defaults:www-data !requiretty 
#  ROOT PRIVILEDGES NEEDED
www-data  ALL=(root) NOPASSWD: /usr/bin/puppet cert list
www-data  ALL=(root) NOPASSWD: /usr/bin/puppet cert list --all
www-data  ALL=(root) NOPASSWD: /usr/bin/puppet cert sign *
www-data  ALL=(root) NOPASSWD: /usr/bin/puppet cert clean *

# PUPPET PRIVILEDGES NEEDED
www-data  ALL=(puppet) NOPASSWD: /usr/bin/git add .
www-data  ALL=(puppet) NOPASSWD: /usr/bin/git reset --hard origin/master
www-data  ALL=(puppet) NOPASSWD: /usr/bin/git pull
```

### Other Configuration

Prepare thin conf
```sh
if [ ! -f /etc/thin1.9.1/app.yml ]; then
  echo "-----> Installation de thin"
  thin install	

  echo "-----> Configuration de thin"
  insserv -d thin
  cat > /etc/thin1.9.1/app.yml << EOL
--- 
user: www-data
group: www-data
timeout: 30
wait: 30
log: /var/log/thin.log
max_conns: 1024
require: []
environment: production
max_persistent_conns: 512
servers: 1
threaded: true
no-epoll: true
daemonize: true
chdir: /var/www/puppetmanager/puppet-manager/
tag: puppetmanager
EOL

fi

/etc/init.d/thin start -C /etc/thin1.9.1/app.yml
```

You can also use nginx to redirect to port 80 and deliver static objects:
```sh
if [ ! -f /etc/nginx/sites-enabled/puppetmanager ]; then
  echo "-----> Configuration de nginx"
  cat > /etc/nginx/sites-enabled/puppetmanager << EOF
server {
  listen   80;
  listen   [::]:80 default ipv6only=on;

  server_name  $(hostname -f);

  access_log  /var/log/nginx/localhost.access.log;

  location / {
    #       rewrite /(.*) /$1 break;
    proxy_pass http://127.0.0.1:3000;
    proxy_redirect     off;
    proxy_set_header   Host             \$host;
    proxy_set_header   X-Real-IP        \$remote_addr;
    proxy_set_header   X-Forwarded-For  \$proxy_add_x_forwarded_for;
  }

  location ~ ^/(assets)/  {
    root /var/www/puppetmanager/puppet-manager/public;
    expires 1y;
    add_header Cache-Control public;
    add_header ETag "";
    break;
  }
}
EOF

fi

service nginx restart
```

You can also add cron :
```sh
if [ ! -f /etc/cron.d/puppetmaster-rake ]; then
  echo "-----> Ajout du cron pour la synchronisation des confs des noeuds"
  cat > /etc/cron.d/puppetmaster-rake << EOF
# tache rake pour peupler le puppetmanager
0 21 * * * root cd /var/www/puppetmanager/puppet-manager/lib/tasks && RAILS_ENV=production /usr/local/bin/rake puppetfacts:getfacts
/2 * * * * root cd /var/www/puppetmanager/puppet-manager/lib/tasks && RAILS_ENV=production /usr/local/bin/rake puppetnodes:import
EOF
fi
```
#!/bin/sh -v
export LANG=C
export PuppetHome=/root/puppet
aptitude install --assume-yes etckeeper git puppet linux-image-amd64 augeas-tools
# Das braucht nochmals etwa zwei Minuten
# etckeeper: lets keep us history of all files under /etc
git config --global user.name "Your Name"     
git config --global user.email you@example.com 
mkdir $PuppetHome
cd $PuppetHome

# clone the various git repositories
# git common elexis-admin, may be rename it to puppet-elexis 
# it will pull in various submodule, eg. https://github.com/ngiger/puppet-x2go
git clone http://github.com/ngiger/elexis-admin
# A medelexis OC probably has some rules of its own, pull them in
git clone http://github.com/ngiger/puppet-example-oc
# It might be wise to have a separate module for each client
# where we administer its configuration, eg. icons, Wiki-content, 
# templates, network configuration. Here it is simply my (private) setup
git clone http://github.com/ngiger/puppet-example-practice

# Use the augeas interactive augtool to configure the puppet modulepath
augtool <<EOF
set  /files/etc/puppet/puppet.conf/main/modulepath \
$PuppetHome/puppet-example-practice/modules:\
$PuppetHome/puppet-example-oc/modules:\
$PuppetHome/elexis-admin/modules
save
EOF

# No we are ready to populate the server
# user --noop and/or --debug if needed
puppet apply $PuppetHome/puppet-example-practice/manifests/site.pp
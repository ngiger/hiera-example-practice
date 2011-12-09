#!/bin/sh -v
export LANG=C
aptitude install etckeeper git puppet linux-image-amd64 
# Das braucht nochmals etwa zwei Minuten
# etckeeper: lets keep us history of all files under /etc
git config --global user.name "Your Name"     
git config --global user.email you@example.com 
export PuppetHome=/root/puppet
mkdir $PuppetHome
cd $PuppetHome
# git common elexis-admin, may be rename it to puppet-elexis 
# it will pull in various submodule, eg. https://github.com/ngiger/puppet-x2go
git clone http://github.com/ngiger/elexis-admin
# A medelexis OC probably has some rules of its own, pull them in
git clone http://github.com/ngiger/puppet-example-oc
# It might be wise to have a separate module for each client
# where we administer its configuration, eg. icons, Wiki-content, 
# templates, network configuration. Here it is simply my (private) setup
git clone http://github.com/ngiger/puppet-example-practice
# No we are ready to populate the server
# user --noop and/or --debug if needed
puppet apply --modulepath=$PuppetHome/puppet-example-practice/modules:\
$PuppetHome/puppet-example-oc/modules:\
$PuppetHome/elexis-admin/modules \
puppet-example-practice/manifests/site.pp
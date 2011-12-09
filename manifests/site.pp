# see also http://www.puppetcookbook.com/posts/create-home-directory-for-managed-users.html

$adminUser = 'niklaus'

user { $adminUser:
   groups => ['adm','dialout'],
   comment => 'This user was created by Puppet',
   ensure => 'present',
   managehome => 'true',
} 

node default {
    include  x2go
    include  x2go::client
  include sudo
  include sudo::install

    include  x2go::client
    include postgres::client
    include postgres::server
    postgres::database { "elexis": ensure => present,
      owner => adminUser
      }
}


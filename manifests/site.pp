# see also http://www.puppetcookbook.com/posts/create-home-directory-for-managed-users.html
user { "niklaus":
   groups => ['adm','x2go']
   commend => 'This user was created by Puppet',
   ensure => 'present',
   managed_home => 'true',

} 
node default {
    include  x2go
    include  x2go::client
  include sudo
  include sudo::install
  include elexis-client

  file{"/tmp/
    include  x2go::client
    include postgres::client
    include postgres::server
      postgres::database { "elexis-psql": ensure => present,
      owner => 'niklaus'
    }
}


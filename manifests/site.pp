# Damit das Ganze schnell geht und der Platzbedarf minimiert wird,
# wird nur eine PostgreSQL-DB aufgesetzt.
# Wenn man mehr will, die x2go-Zeilen ausklammern


# Konfigurationsdateien (Kleines Beispiel)

$adminUser = 'niklaus'
$dbname    = 'elexis'

user { $adminUser:
   groups => ['adm','dialout'],
   comment => 'This user was created by Puppet',
   ensure => 'present',
   managehome => 'true',
} 

node default {
#    include  x2go::client
#    include  x2go::server
    include sudo::install
    include postgres::client
    include postgres::server
    postgres::database { "elexis": ensure => present,
      owner => adminUser
      }
}

# Niklaus will, dass immer VIM installiert und als default editor verwendet wird

package { vim:
        ensure => installed,
}
define check_alternatives($linkto) {
  exec { "/usr/sbin/update-alternatives --set $name $linkto":
    unless => "/bin/sh -c '[ -L /etc/alternatives/$name ] && [ /etc/alternatives/$name -ef $linkto ]'"
  }
}

check_alternatives { "editor":
  linkto => "/usr/bin/vim.basic"
}

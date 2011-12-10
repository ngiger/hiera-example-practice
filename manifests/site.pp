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
#    include postgres::client
#    include postgres::server
#    postgres::database { "elexis": ensure => present,
#      owner => adminUser
#      }
}

# Augeas Linsen sind cool! siehe http://projects.puppetlabs.com/projects/1/wiki/Puppet_Augeas
# und http://augeas.net/tour.html

# Diesen Server kann ich via diese IP und diverse Aliase erreichen
$fixIp_1 = '192.168.168.168'
augeas { "some_fixed_ip":
  context => "/files/etc/hosts",
  changes => [
    "set 01[ipaddr = '$fixIp_1']/ipaddr $fixIp_1",
    "set 01[ipaddr = '$fixIp_1']/canonical some_fixed_ip",
    "set 01[ipaddr = '$fixIp_1']/alias[1] aka",
    "set 01[ipaddr = '$fixIp_1']/alias[2] ichNenneDichSo",
  ],
  onlyif => "match *[ipaddr = '$fixIp_1'] size == 0",
}

# Niklaus will, dass immer vi installiert und als default editor verwendet wird

package { vim:
        ensure => installed,
}
define check_alternatives($linkto) {
  exec { "/usr/sbin/update-alternatives --set $name $linkto":
    unless => "/bin/sh -c '[ -L /etc/alternatives/$name ] && [ /etc/alternatives/$name -ef $linkto ]'"
  }
}

check_alternatives { "editor":
  linkto => "/usr/bin/vim.basic",
  require => Package["vim"],
}

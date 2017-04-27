case $facts['os']['name'] {
  'Solaris':           { include role::solaris } # Apply the solaris class
  'RedHat', 'CentOS':  { include role::redhat  } # Apply the redhat class
  /^(Debian|Ubuntu)$/: { include role::debian  } # Apply the debian class
  default:             { include role::generic } # Apply the generic class
}




group { 'cognosgrp1':
  			  ensure => 'present',
  			  gid    => '551',
     }

group { 'cognosgrp2':
  			  ensure => 'present',
  			  gid    => '552',
     

## password is same as user
user { 'cognos1':
 			ensure           => 'present',
      home             => '/home/cognos1',
      comment          => 'service account',
      groups           => 'cognosgrp1',
      password         => '$6$salt$lG0TId1khdHnoxmnhe7jl5/zvlFFUbknSf3ZyD2PuJ5rhKiEjI3L7KujcNjBhBdjapi8hujYqG/I4ajVbr2Pr1',
      password_max_age => '99999',
      password_min_age => '0',
      shell            => '/bin/bash',
      uid              => '1551',
      managehome       => true,
    }

# pssword is same as user
user { 'cognos2':
 			ensure           => 'present',
      home             => '/home/cognos2',
      comment          => 'service account',
      groups           => 'cognosgrp2',
      password         => '$6$salt$Kr1qMlv.v5VSwZtKZhNdDYcrmeEsEgUoBctr1Zk.T9XYEWfo0DIeBUrwbRXCq1qXYCQ6ueRXA4rbw3RA.2WEg/',
      password_max_age => '99999',
      password_min_age => '0',
      shell            => '/bin/bash',
      uid              => '1552',
      managehome       => true,
    }






# execute 'apt-get update'
exec { 'apt-update':                    # exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}



package { [
  'puppet',
  'nano',
  'tmux',
  'screen',
  'htop',
  'nethogs',
  'bash-completion',
  ]:
  ensure => 'latest',
}


$ssh_service = $operatingsystem ? {
    /CentOS|RedHat/  => 'sshd',
    default          => 'ssh' ,
}

package { 'openssh-server':
    ensure => 'latest',
}

service { 'ssh':
    name   => $ssh_service
    ensure => running,
    enable => true,
    require => Package['openssh-server']
}

augeas { "configure_sshd":
        context => "/files/etc/ssh/sshd_config",
        changes =>      [       "set PasswordAuthentication yes",
                                "set UsePAM yes",
                        ],
        require => Package["openssh-server"],
        notify  => Service["ssh"]
}




package { [
  'libc6:i386',
  'libc6:amd64',
  'libstdc++6:i386',
  'libstdc++6:amd64',
  'libnspr4',
  'libnss3',
  'libmotif3',
  ]:
  ensure => 'installed',
}

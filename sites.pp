# execute 'apt-get update'
exec { 'apt-update':                    # exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}



package { [
  'puppet',
  'tmux',
  'screen',
  'htop',
  'nethogs',
  'bash-completion',
  ]:
  ensure => 'latest',
}


package { 'openssh-server':
    ensure => 'latest',
}

service { 'ssh':
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


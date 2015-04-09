class freifunk-openvpn() {

  # add custom repository for freifunk-openvpn (patched openvpn version)
  apt::source { 'sven_ola':
    comment     => 'sven-olas repo for openvpn and other stuff',
    location    => 'http://sven-ola.dyndns.org/repo',
    release     => 'trusty',
    repos       => 'main',
    pin         => '500',
    include_deb => true,
    include_src => false,
    key         => 'AF1714D11903D0B2',
  }
  package { 'freifunk-openvpn':
    ensure => present,
    require => Apt::Source['sven_ola'],
  }

  # ipfilter commands and e.g. NAT configuration
  file { '/etc/rc.local':
    ensure  => present,
    content => template('freifunk-openvpn/rc.local.erb'),
  }

  # script we use to change the NAT mapping
  file { '/etc/cron.daily/roulette':
    ensure  => present,
    content => template('freifunk-openvpn/roulette.erb'),
  }

  # script we use to learn the back route
  file { '/etc/openvpn/openvpn-learn-address':
    ensure  => present,
    content => template('freifunk-openvpn/openvpn-learn-address.erb'),
  }

  # tcp and udp openvpn server configuration
  file { '/etc/openvpn/server-tcp.conf':
    ensure  => present,
    content => template('freifunk-openvpn/server-tcp.conf.erb'),
  }
  file { '/etc/openvpn/server-udp.conf':
    ensure  => present,
    content => template('freifunk-openvpn/server-udp.conf.erb'),
  }

  sysctl { 'net.ipv4.ip_forward': value => '1' }
}

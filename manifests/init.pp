#
class hpacucli () {

  file {'/usr/bin/hpatool.sh':
    source => 'puppet:///modules/hpacucli/hpatool.sh',
    mode   => '0700'
  }

  file {"/etc/apt/sources.list.d/hpa.list":
    content => 'deb http://bpamirror:81/hpa ./',
    notify => Exec['apt-get-update']
  } ->
  exec {'/usr/bin/apt-get -q -y --allow-unauthenticated -o DPkg::Options::=--force-confold install hpacucli':}
}

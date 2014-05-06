#
class hpacucli () {

  file {'/usr/bin/hpatool.sh':
    source => 'puppet:///modules/hpa/hpatool.sh',
    mode   => '0700'
  }

  exec {'/usr/bin/apt-get -q -y --allow-unauthenticated -o DPkg::Options::=--force-confold install hpacucli':}
}

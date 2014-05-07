#
class hpacucli () {

  file {'/usr/bin/hpatool.sh':
    source => 'puppet:///modules/hpacucli/hpatool.sh',
    mode   => '0700'
  }

  class {"repo::hpacucli":} ->
  exec {'/usr/bin/apt-get -q -y --allow-unauthenticated -o DPkg::Options::=--force-confold install hpacucli':}
}

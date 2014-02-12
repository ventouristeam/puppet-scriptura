class scriptura::server::package(
  $version=undef,
  $versionlock=false
) {

  package { 'scriptura-engage-server':
    ensure => $version
  }

  case $versionlock {
    true: {
      packagelock { "scriptura-engage-server": }
    }
    false: {
      packagelock { "scriptura-engage-server": ensure => absent }
    }
    default: { fail('Class[Scriptura::Server::Package]: parameter versionlock must be true or false')}
  }

}

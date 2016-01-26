define scriptura::iac::server::package(
  $version=undef,
  $versionlock=false,
  $type=undef
) {

  package { "scriptura-engage-${type}":
    ensure => $version
  }

  case $versionlock {
    true: {
      packagelock { "scriptura-engage-${type}": }
    }
    false: {
      packagelock { "scriptura-engage-${type}": ensure => absent }
    }
    default: { fail('Class[Scriptura::Iac::Server::Package]: parameter versionlock must be true or false')}
  }

}

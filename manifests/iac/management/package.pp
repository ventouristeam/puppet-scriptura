class scriptura::iac::management::package(
  $version=undef,
  $versionlock=false
) {

  package { 'scriptura-engage-management':
    ensure => $version
  }

  case $versionlock {
    true: {
      packagelock { 'scriptura-engage-management': }
    }
    false: {
      packagelock { 'scriptura-engage-management': ensure => absent }
    }
    default: { fail('Class[Scriptura::Iac::Management::Package]: parameter versionlock must be true or false')}
  }

}

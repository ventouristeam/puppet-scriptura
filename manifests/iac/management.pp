define scriptura::iac::management(
  $version=undef,
  $versionlock=false
) {

  include stdlib

  anchor { 'scriptura::iac::management::begin': }
  anchor { 'scriptura::iac::management::end': }

  if ! $version {
    fail('Class[Scriptura::Iac::Management]: parameter version must be provided')
  }

  class { 'scriptura::iac::management::package':
    version     => $version,
    versionlock => $versionlock
  }

  include scriptura::iac::management::config
  include scriptura::iac::management::service

  Anchor['scriptura::iac::management::begin'] -> Class['Scriptura::Iac::Management::Package'] -> Class['Scriptura::Iac::Management::Config'] ~> Class['Scriptura::Iac::Management::Service'] -> Anchor['scriptura::iac::management::end']

}

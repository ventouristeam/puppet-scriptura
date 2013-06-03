class scriptura::management($version=undef) {

  if ! $version {
    fail('Class[Scriptura::Management]: parameter version must be provided')
  }

  class { 'scriptura::management::package':
    version => $version
  }

  include scriptura::management::config
  include scriptura::management::service

  Class['Scriptura::Management::Package'] -> Class['Scriptura::Management::Config'] ~> Class['Scriptura::Management::Service']

}

class scriptura::management::package($version=undef) {

  package { 'scriptura-engage-management':
    ensure => $version
  }

}

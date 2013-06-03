class scriptura::server::package($version=undef) {

  package { 'scriptura-engage-server':
    ensure => $version
  }

}

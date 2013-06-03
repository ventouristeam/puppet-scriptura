class scriptura::server::service {

  service { 'scriptura-engage-server':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true
  }

}

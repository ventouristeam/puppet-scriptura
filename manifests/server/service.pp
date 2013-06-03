class scriptura::server::service {

  service { 'scriptura-engage-server':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }

}

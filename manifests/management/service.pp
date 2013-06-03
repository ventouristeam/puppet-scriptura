class scriptura::management::service {

  service { 'scriptura-engage-management':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }

}

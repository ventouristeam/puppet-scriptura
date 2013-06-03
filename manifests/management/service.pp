class scriptura::management::service {

  service { 'scriptura-engage-management':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true
  }

}

define scriptura::server::service (
  $type=undef,
  $ensure=running
) {

  service { "scriptura-engage-${type}":
    ensure     => $ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }

}

class scriptura::server::config($key_server=undef, $server_category='production') {

  file { '/opt/scriptura/configuration.xml' :
    ensure  => file,
    owner   => 'scriptura',
    group   => 'scriptura',
    content => template("${module_name}/server/configuration.xml.erb")
  }

}

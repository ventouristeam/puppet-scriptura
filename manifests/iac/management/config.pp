class scriptura::iac::management::config {

  file { '/opt/scriptura/configuration.xml' :
    ensure  => file,
    owner   => 'scriptura',
    group   => 'scriptura',
    content => template("${module_name}/iac/management/configuration.xml.erb")
  }

}

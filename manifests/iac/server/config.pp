# Resource: scriptura::iac::server::config
#
define scriptura::iac::server::config(
  $version=undef,
  $type=undef,
  $base_url=undef,
  $hostname=undef,
  $havail_dir=undef,
  $key_server_url=undef,
  $key_server_username=undef,
  $key_server_password=undef,
  $security_server_url,
  $security_server_key,
  $server_category='production',
  $mail_host=undef,
  $core_min_threads='20',
  $core_max_threads='20',
  $cache_max_memory_entries='100',
  $cache_max_disk_space='500',
  $cache_max_disk_entries='200',
  $data_dir='/data/scriptura',
  $fonts_dir='/data/scriptura/Fonts',
  $logger_max_file_index='50',
  $logger_max_file_size='2048',
  $startup_options=undef
) {

  if ! ($type in [ 'frontend', 'resource', 'process' ]) {
    fail("Scriptura engage type '${type}' is not valid")
  }

  $scriptura_version_withoutrelease = regsubst($version, '^(\d+\.\d+\.\d+)-\d+\..*$', '\1')
  notice("Scriptura engage ${type} version without release: ${scriptura_version_withoutrelease}")
  $scriptura_major_minor_version = regsubst($scriptura_version_withoutrelease, '^(\d+\.\d+).\d+$', '\1')
  notice("Scriptura engage ${type} major and minor version: ${scriptura_major_minor_version}")

  $scriptura_settings_location = "/${data_dir}/${type}/scriptura-${scriptura_major_minor_version}"
  $scriptura_config_location = "/${data_dir}/${type}/scriptura-${scriptura_major_minor_version}/configuration"
  $scriptura_config_xml = hiera_hash("scriptura::iac::server::config::xml::${type}",{})
  $initcap_type = capitalize($type)

  file { $scriptura_settings_location :
    ensure => directory,
    owner  => 'scriptura',
    group  => 'scriptura',
    mode   => '0755'
  }

  file { $scriptura_config_location :
    ensure  => directory,
    owner   => 'scriptura',
    group   => 'scriptura',
    mode    => '0755',
    require => File[$scriptura_settings_location]
  }

  file { "${scriptura_config_location}/configuration.xml":
    ensure  => file,
    owner   => 'scriptura',
    group   => 'scriptura',
    content => template("${module_name}/iac/server/configuration-${type}.xml.erb"),
    replace => false,
    require => File[$scriptura_config_location]
  }

  if $scriptura_config_xml {
    create_resources('augeas',$scriptura_config_xml)
  }

  if defined('$startup_options') {
    file { "/opt/scriptura/${$type}/start${$type}server/ScripturaStart${initcap_type}Server.ini":
      ensure  => file,
      owner   => 'scriptura',
      group   => 'scriptura',
      content => template("${module_name}/iac/server/ScripturaStart${initcap_type}Server.ini.erb"),
      replace => true,
      require => File[$scriptura_config_location]
    }
  }

}

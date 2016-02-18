#scriptura::iac::server::config::xml:
#  'scriptura-engage-resource_configuration.xml':
#    lens: 'Xml.lns'
#    incl: '/scriptura.home/scriptura-8.0/configuration/configuration.xml'
#    context: '/files/scriptura.home/scriptura-8.0/configuration/configuration.xml'
#    changes:
#      - 'set config/templateprocessor/core/min-threads/#text 20'
#      - 'set config/templateprocessor/core/max-threads/#text 20'
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
  $fonts_dir='/data/scriptura/Fonts',
  $logger_max_file_index='50',
  $logger_max_file_size='2048'
) {

  $scriptura_version_withoutrelease = regsubst($version, '^(\d+\.\d+\.\d+)-\d+\..*$', '\1')
  notice("Scriptura engage ${type} version without release: ${scriptura_version_withoutrelease}")
  $scriptura_major_minor_version = regsubst($scriptura_version_withoutrelease, '^(\d+\.\d+).\d+$', '\1')
  notice("Scriptura engage ${type} major and minor version: ${scriptura_major_minor_version}")

  $scriptura_config_location = "/data/scriptura/${type}/scriptura-${scriptura_major_minor_version}/configuration"
  $scriptura_config_xml = hiera_hash('scriptura::iac::server::config::xml',{})

  if ! defined(File['/data/scriptura']){
    file { '/data/scriptura' :
      ensure => directory,
      owner  => 'scriptura',
      group  => 'scriptura',
      mode   => '0770'
    }
  }

  file { "/data/scriptura/${type}/{scriptura-engage-${type}-${scriptura_major_minor_version}" :
    ensure => directory,
    owner  => 'scriptura',
    group  => 'scriptura',
    mode   => '0755'
  }

  file { "${scriptura_config_location}" :
    ensure  => directory,
    owner   => 'scriptura',
    group   => 'scriptura',
    mode    => '0755',
    require => File["/data/scriptura/scriptura-engage-${type}-${scriptura_major_minor_version}"]
  }

  file { "${scriptura_config_location}/configuration.xml":
    ensure  => file,
    owner   => 'scriptura',
    group   => 'scriptura',
    source  => "puppet:///modules/${module_name}/server/data/configuration-${type}.xml",
    replace => false,
    require => File["${scriptura_config_location}"]
  }

  if defined($scriptura_config_xml) {
    create_resources('augeas',$scriptura_config_xml)
  }

}

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

  if ! defined(File['/data/scriptura']){
    file { '/data/scriptura' :
      ensure => directory,
      owner  => 'scriptura',
      group  => 'scriptura',
      mode   => '0770'
    }
  }

  file { "/data/scriptura/scriptura-engage-${type}-${scriptura_major_minor_version}" :
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

  augeas { "modify configuration.xml in ${scriptura_config_location}" :
    lens    => 'Xml.lns',
    incl    => "${scriptura_config_location}/configuration.xml",
    context => "/files${scriptura_config_location}/configuration.xml",
    changes => [
      "set config/templateprocessor/fonts/directories/directory0/#text ${fonts_dir}",
      "set config/license/client/keyserver/uri/#text ${key_server_url}",
      "set config/server/security/security-server-location/#text ${key_server_url}",
      "set config/server/security/key/public/#text ${key_server_pubkey}",
      "set config/generic/hostname/#text ${base_name}",
      "set config/cloud/connection/service/endpoint/#text ${key_server_url}",
      "set config/cloud/connection/server/username/#text ${key_server_user}",
      "set config/cloud/connection/server/password/#text ${key_server_pass}",
      "set config/cloud/baseurl/${type}/#text ${base_url}",
      #"set config/templateprocessor/mail/com.id.scriptura.templateprocessor.email.impl.javamail/host/#text ${mail_host}",
      #"set config/templateprocessor/core/min-threads/#text ${core_min_threads}",
      #"set config/templateprocessor/core/max-threads/#text ${core_max_threads}",
      #"set config/templateprocessor/cache/max-memory-entries/#text ${cache_max_memory_entries}",
      #"set config/templateprocessor/cache/max-disk-space/#text ${cache_max_disk_space}",
      #"set config/templateprocessor/cache/max-disk-entries/#text ${cache_max_disk_entries}",
      #"set config/generic/logger/max-file-index/#text ${logger_max_file_index}",
      #"set config/generic/logger/max-file-size/#text ${logger_max_file_size}",
    ],
    require => File["${scriptura_config_location}/configuration.xml"]
  }

}

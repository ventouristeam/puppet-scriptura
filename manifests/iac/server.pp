define scriptura::iac::server(
  $version=undef,
  $versionlock=false,
  $type=undef,
  $base_url=undef,
  $hostname=undef,
  $havail_dir=undef,
  $key_server_url=undef,
  $key_server_username=undef,
  $key_server_password=undef,
  $security_server_url=undef,
  $security_server_key=undef,
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

  include stdlib

  if ! $version {
    fail('Class[Scriptura::IAC::Server]: parameter version must be provided')
  }

  if ! $key_server_url {
    fail('Class[Scriptura::IAC::Server]: parameter key_server_url must be provided')
  }

  if ! ($server_category in ['auto', 'production', 'backup', 'test', 'development']) {
    fail('Class[Scriptura::IAC::Server]: parameter server_category must be auto, production, backup, test or development')
  }

  if ! $mail_host {
    fail('Class[Scriptura::IAC::Server]: parameter mail_host must be provided')
  }

  if ! $type {
    fail('Class[Scriptura::IAC::Server]: parameter type must be provided')
  }

  scriptura::iac::server::package { "scriptura-engage-$type" :
    type        => $type,
    version     => $version,
    versionlock => $versionlock
  }

  scriptura::iac::server::config { "scriptura-engage-$type" :
    version                   => $version,
    type                      => $type,
    base_url                  => $base_url,
    hostname                  => $hostname,
    havail_dir                => $havail_dir,
    key_server_url            => $key_server_url,
    key_server_username       => $key_server_username,
    key_server_password       => $key_server_password,
    security_server_url       => $security_server_url,
    security_server_key       => $security_server_key,
    server_category           => $server_category,
    mail_host                 => $mail_host,
    core_min_threads          => $core_min_threads,
    core_max_threads          => $core_max_threads,
    cache_max_memory_entries  => $cache_max_memory_entries,
    cache_max_disk_space      => $cache_max_disk_space,
    cache_max_disk_entries    => $cache_max_disk_entries,
    fonts_dir                 => $fonts_dir,
    logger_max_file_index     => $logger_max_file_index,
    logger_max_file_size      => $logger_max_file_size,
    require                   => Scriptura::Iac::Server::Package["scriptura-engage-$type"]
  }

  scriptura::iac::server::service { "scriptura-engage-$type" :
    type    => $type,
    require => Scriptura::Iac::Server::Config["scriptura-engage-$type"]
  }

}

define scriptura::iac::server(
  $version=undef,
  $versionlock=false,
  $type=undef,
  $key_server=undef,
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

  anchor { 'scriptura::iac::server::begin': }
  anchor { 'scriptura::iac::server::end': }

  if ! $version {
    fail('Class[Scriptura::IAC::Server]: parameter version must be provided')
  }

  if ! $key_server {
    fail('Class[Scriptura::IAC::Server]: parameter key_server must be provided')
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
    version     => $version,
    versionlock => $versionlock
  }

  scriptura::iac::server::config { "scriptura-engage-$type" :
    version                  => $version,
    type                     => $type,
    key_server               => $key_server,
    server_category          => $server_category,
    mail_host                => $mail_host,
    core_min_threads         => $core_min_threads,
    core_max_threads         => $core_max_threads,
    cache_max_memory_entries => $cache_max_memory_entries,
    cache_max_disk_space     => $cache_max_disk_space,
    cache_max_disk_entries   => $cache_max_disk_entries,
    fonts_dir                => $fonts_dir,
    logger_max_file_index    => $logger_max_file_index,
    logger_max_file_size     => $logger_max_file_size
  }

  include scriptura::server::service

  Anchor['scriptura::iac::server::begin'] -> Class['Scriptura::Iac::Server::Package'] -> Class['Scriptura::Iac::Server::Config'] ~> Class['Scriptura::Iac::Server::Service'] -> Anchor['scriptura::iac::server::end']

}

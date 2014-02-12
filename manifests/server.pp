class scriptura::server(
  $version=undef,
  $versionlock=false,
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

  anchor { 'scriptura::server::begin': }
  anchor { 'scriptura::server::end': }

  if ! $version {
    fail('Class[Scriptura::Server]: parameter version must be provided')
  }

  if ! $key_server {
    fail('Class[Scriptura::Server]: parameter key_server must be provided')
  }

  if ! ($server_category in ['auto', 'production', 'backup', 'test', 'development']) {
    fail('Class[Scriptura::Server]: parameter server_category must be auto, production, backup, test or development')
  }

  if ! $mail_host {
    fail('Class[Scriptura::Server]: parameter mail_host must be provided')
  }

  class { 'scriptura::server::package':
    version     => $version,
    versionlock => $versionlock
  }

  class { 'scriptura::server::config':
    version                  => $version,
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

  Anchor['scriptura::server::begin'] -> Class['Scriptura::Server::Package'] -> Class['Scriptura::Server::Config'] ~> Class['Scriptura::Server::Service'] -> Anchor['scriptura::server::end']

}

class scriptura::server($version=undef, $key_server=undef, $server_category='production') {

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

  class { 'scriptura::server::package':
    version => $version
  }

  class { 'scriptura::server::config':
    key_server      => $key_server,
    server_category => $server_category
  }

  include scriptura::server::service

  Anchor['scriptura::server::begin'] -> Class['Scriptura::Server::Package'] -> Class['Scriptura::Server::Config'] ~> Class['Scriptura::Server::Service'] -> Anchor['scriptura::server::end']

}

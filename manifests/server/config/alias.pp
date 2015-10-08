define scriptura::server::config::alias(
  $version = undef,
  $type = undef,
  $name = undef
) {

  if ($type == undef or $name == undef) {
    fail("Scriptura::Server::Config::Alias[${title}]: parameters version, type and name must be defined")
  }

  $scriptura_version_withoutrelease = regsubst($version, '^(\d+\.\d+\.\d+)-\d+\..*$', '\1')
  $scriptura_major_minor_version = regsubst($scriptura_version_withoutrelease, '^(\d+\.\d+).\d+$', '\1')
  $scriptura_config_location = "/data/scriptura/scriptura-${scriptura_major_minor_version}/configuration"

  augeas { "scriptura/configuration/aliases/${title}/add" :
    lens    => 'Xml.lns',
    incl    => "${scriptura_config_location}/configuration.xml",
    context => "/files/${scriptura_config_location}/configuration.xml",
    changes => [
      "set config/aliases/${title}/alias-name/#text ${name}",
      "set config/aliases/${title}/alias-type/#text ${type}"
    ],
    onlyif  => "match config/aliases/${title}/alias-name/#text[. = \"${name}\"] size == 0"
  }

}

# Define: scriptura::server::config::element
#
# You can use this for settings that are not complicated and start directly under the <config> tag in the configuration
#
# Sample Usage:
#
# scriptura::server::config::element { 'documentflowprocessor/max-threads':
#   version => '7.3.24-1.cgk.el6',
#   value   => '500'
# }
#
define scriptura::server::config::element(
  $version = undef,
  $value = undef
) {

  if ($type == undef or $name == undef) {
    fail("Scriptura::Server::Config::Element[${title}]: parameters version and value must be defined")
  }

  $scriptura_version_withoutrelease = regsubst($version, '^(\d+\.\d+\.\d+)-\d+\..*$', '\1')
  $scriptura_major_minor_version = regsubst($scriptura_version_withoutrelease, '^(\d+\.\d+).\d+$', '\1')
  $scriptura_config_location = "/data/scriptura/scriptura-${scriptura_major_minor_version}/configuration"

  augeas { "scriptura/configuration/config/${title}/add" :
    lens    => 'Xml.lns',
    incl    => "${scriptura_config_location}/configuration.xml",
    context => "/files/${scriptura_config_location}/configuration.xml",
    changes => [
      "set config/${title}/#text ${value}",
    ],
    onlyif  => "match config/${title}/#text[. = \"${value}\"] size == 0"
  }

}

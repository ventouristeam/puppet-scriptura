class scriptura::workstation {

  include scriptura::workstation::package
  include scriptura::workstation::config
  include scriptura::workstation::service

  Class['Scriptura::Workstation::Package'] -> Class['Scriptura::Workstation::Config'] ~> Class['Scriptura::Workstation::Service']

}

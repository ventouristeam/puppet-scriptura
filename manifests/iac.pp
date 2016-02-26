# Class: scriptura::iac
#
# This module manages scriptura
#
# Parameters:
#
# Actions:
#
# Requires:
# Hiera data:
#   scriptura::iac::data_dir:
#     '/data/scriptura':
#       ensure: 'directory'
#       owner:  'scriptura'
#       group:  'scriptura'#       
#
# Sample Usage:
#
class scriptura::iac {

  $data_dir = hiera_hash('scriptura::iac::data_dir',{})

  create_resources(file,$data_dir)

}

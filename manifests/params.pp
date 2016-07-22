class fluentd::params {
  # package params
  $package_ensure          = 'installed'
  $package_name            = 'google-fluentd'
  $package_install_options = []
  # Install the google catch-all package
  $google_catch_all        = installed
  # service params
  $service_manage = true
  $service_name   = 'google-fluentd'
  $service_ensure = 'running'
  $service_enable = true
  # config params
  $config_path = '/etc/google-fluentd'
  $conf_dir    = "${config_path}/config.d"
  $config_file = "${config_path}/google-fluentd.conf"
  # user params
  $user_manage = false
  $user_name   = 'google-fluentd'
  $user_group  = 'google-fluentd'
  $user_groups = ['adm']

  case $::osfamily {
    'Debian': {
      $repo_manage = false
    }
    'Redhat': {
      $repo_manage = true
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }
}

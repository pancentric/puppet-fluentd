# Class: fluentd
# ===========================
#
# Installs and configures Fluentd.
#
# Parameters
# ----------
# [*repo_manage*]
#   Include repository to install recent fluentd (google-fluentd) from
#   Default: 'true'
# [*package_ensure*]
#   Package ensure
#   Default: 'installed'
# [*package_name*]
#   Package name
#   Default: 'google-fluentd'
# [*package_install_options*]
#   Package install options
#   Default: '[]'
# [*service_manage*]
#   Defines if the service should be managed by puppet
#   Default: 'true'
# [*service_name*]
#   Name of the service
#   Default: 'google-fluentd'
# [*service_ensure*]
#   Service ensure
#   Default: 'running'
# [*service_enable*]
#   Defines if the service should be enabled
#   Default: 'true'
# [*user_manage*]
#   Defines if the user should be manage, which will add the user
#   to groups defined in $user_groups.
#   For example to be able to view the /var/log directory with group adm
#   Default: 'true'
# [*user_name*]
#   Default: 'google-fluentd'
# [*user_group*]
#   Default: 'google-fluentd'
# [*user_groups*]
#   Default: '["adm"]'
#
# Examples
# --------
#
# @example
#    include '::fluentd'
#
# Copyright
# ---------
#
# Copyright 2015 wywy GmbH, unless otherwise noted.
#
class fluentd (
  $repo_manage             = $::fluentd::params::repo_manage,
  $package_ensure          = $::fluentd::params::package_ensure,
  $package_name            = $::fluentd::params::package_name,
  $google_catch_all        = $::fluentd::params::google_catch_all,
  $package_install_options = $::fluentd::params::package_install_options,
  $service_manage          = $::fluentd::params::service_manage,
  $service_name            = $::fluentd::params::service_name,
  $service_ensure          = $::fluentd::params::service_ensure,
  $service_enable          = $::fluentd::params::service_enable,
  $config_path             = $::fluentd::params::config_path,
  $conf_dir                = $::fluentd::params::conf_dir,
  $config_file             = $::fluentd::params::config_file,
  $user_manage             = $::fluentd::params::user_manage,
  $user_name               = $::fluentd::params::user_name,
  $user_group              = $::fluentd::params::user_group,
  $user_groups             = $::fluentd::params::user_groups,

  $deep_merge              = true,

  $sources                 = {},
  $filters                 = {},
  $matches                 = {},
) inherits fluentd::params {

  # parameter validation
  validate_bool($repo_manage)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_array($package_install_options)
  validate_bool($service_manage)
  validate_string($service_name)
  validate_bool($service_enable)

  # validate hiera
  validate_hash($sources)
  validate_hash($filters)
  validate_hash($matches)

  if ! ($service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if ( $deep_merge ) {
    $sources = hiera_hash('fluentd::sources')
    $filters = hiera_hash('fluentd::filters')
    $matches = hiera_hash('fluentd::matches')
  }

  create_resources('::fluentd::source',$sources)
  create_resources('::fluentd::filter',$filters)
  create_resources('::fluentd::match',$matches)

  # class calls
  include '::fluentd::repo'
  include '::fluentd::install'
  include '::fluentd::user'
  include '::fluentd::config'
  include '::fluentd::service'

  # dependencies
  Class['::Fluentd::Repo']    ->
  Class['::Fluentd::Install'] ->
  Class['::Fluentd::User']    ->
  Class['::Fluentd::Config']  ->
  Class['::Fluentd::Service']
}

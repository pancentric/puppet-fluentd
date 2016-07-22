# Configure package
#
class fluentd::install inherits fluentd {

  package { "$::fluentd::package_name":
    ensure          => $::fluentd::package_ensure,
    name            => $::fluentd::package_name,
    install_options => $::fluentd::package_install_options,
  }

}

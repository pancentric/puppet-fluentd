# Configure apt::source
#
class fluentd::repo::apt (
  $ensure   = 'present',
  $location = downcase('http://packages.cloud.google.com/apt'),
  $release  = 'google-cloud-logging-wheezy',
  $repos    = 'main',
  $key      = {
    'id'     => 'D0BC747FD8CAF7117500D6FA3746C208A7317B0F',
    'server' => 'pgp.mit.edu'
  },
  $include      = {
    'src' => false,
    'deb' => true,
  },
) {

  include '::apt'

  apt::source { 'google-cloud-packages':
    ensure   => $ensure,
    location => $location,
    release  => $release,
    repos    => $repos,
    key      => $key,
    include  => $include,
  }
}

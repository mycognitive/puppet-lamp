# == Class: solr
#
# Solr class for installing and configuring Apache Solr.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)


class solr (
  $backend = $solr::params::backend,
  $home_dir = $solr::params::solr_home_dir,
  $data_dir = $solr::params::solr_data_dir,
  $ensure = $solr::params::ensure
) inherits solr::params {
  include solr::packages
  include solr::files
  include solr::config
  include solr::services

  Class['solr::packages'] -> Class ['solr::files'] -> Class['solr::config'] -> Class['solr::services']
}


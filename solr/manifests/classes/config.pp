class solr::config {
  $tomcat_user = $operatingsystem ? {
    /RedHat|CentOS/ => "tomcat",
    /Debian|Ubuntu/ => "tomcat7",
  }

  $tomcat_conf_file = $operatingsystem ? {
    /RedHat|CentOS/ => "/etc/sysconfig/tomcat7",
    /Debian|Ubuntu/ => "/etc/default/tomcat7",
  }

  file { 'solr home dir' :
    path => $solr::home_dir,
    ensure => directory,
    recurse => true,
  }

  file { 'solr data dir' :
    path => $solr::data_dir,
    ensure => directory,
    recurse => true,
    owner => $tomcat_user,
    group => $tomcat_user,
  }

  augeas { "solr config":
    changes => [
      "set /files${tomcat_conf_file}/JAVA_OPTS '\"-Djava.awt.headless=true -Dsolr.solr.home=${solr::home_dir} -Dsolr.data.dir=${solr::data_dir} -Xmx128m -XX:+UseConcMarkSweepGC\"'",
    ],
    require => [File["solr home dir"], File["solr data dir"]],
    notify => Service["tomcat7"],
  }

  file { "/etc/tomcat7/server.xml":
    ensure => present,
    source => "/etc/tomcat7/server.xml",
    notify => Service["tomcat7"],
    owner => $tomcat_user,
    group => $tomcat_user,
  }
}

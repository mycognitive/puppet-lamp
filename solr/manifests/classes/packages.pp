class solr::packages inherits solr::params {
  if ! defined(Package['curl']) { package { 'curl': ensure => installed, } }

  package { [ "tomcat7", "tomcat7-admin" ]:
    ensure => present,
  }

  package { "java":
    ensure => present,
    name => $operatingsystem ? {
      'Centos' => $operatingsystemrelease ? {
        '6.0' => "java-1.6.0-openjdk.$hardwaremodel",
         '*' => 'openjdk-7-jre',
      },
      'Debian' => 'openjdk-7-jre-headless',
      'Ubuntu' => 'openjdk-7-jre-headless',
    },
  }

}

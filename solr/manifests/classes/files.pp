class solr::files {
  $dir = $solr::params::solr_dir

  exec { "download_solr":
    cwd => "/tmp",
    command => "/usr/bin/curl -O http://archive.apache.org/dist/lucene/solr/4.9.1/solr-4.9.1.tgz",
    creates => ["/tmp/solr-4.9.1.tgz", "/var/lib/tomcat7/webapps/solr.war"],
    notify => Exec['solr::files::unpack_solr'],
    timeout => 60,
  }

  exec { "unpack_solr":
    cwd => "/tmp",
    command => "/bin/tar xzvf /tmp/solr-4.9.1.tgz",
    creates => ["/tmp/solr-4.9.1", "/var/lib/tomcat7/webapps/solr.war"],
    require => Exec["download_solr"],
  }

  exec { "deploy_solr":
    cwd => "/tmp",
    command => "/bin/mv -v /tmp/solr-4.9.1/dist/solr-4.9.1.war /var/lib/tomcat7/webapps/solr.war",
    creates => "/var/lib/tomcat7/webapps/solr.war",
    require => Exec["unpack_solr"],
  }

  exec { "remove_tar":
    cwd => "/tmp",
    command => "/bin/rm -v /tmp/solr-4.9.1.tgz",
    require => [ Exec["unpack_solr"] ],
  }

  file { "/opt/solr":
    ensure => directory,
    owner => 'tomcat7',
    group => 'tomcat7',
    mode => 0644,
  }
  file { "/opt/solr/data":
    ensure  => directory,
    owner   => tomcat7,
    group   => tomcat7,
    mode    => 2750,
  }
  file { "/var/log/solr":
    ensure => directory,
    owner => root,
    group => root,
    mode => 0644,
  }

}

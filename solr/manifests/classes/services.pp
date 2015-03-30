class solr::services {
  service { "tomcat7":
      ensure => $solr::ensure,
      enable => "true",
    }
}

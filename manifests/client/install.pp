class postgresql::client::install(
  $version
){
  
  package{'postgresql_client':
    ensure  => installed,
    name    => $operatingsystem ? {
      Ubuntu  => "postgresql-client-${version}",
      default => 'postgresql-client',
    }
  }

}
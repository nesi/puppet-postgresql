class postgresql::client::install(
  $version
){
  
  package{'libpq-dev':
    ensure  => installed,
    name    => $operatingsystem ? {
      Ubuntu  => "libpq-dev",
      default => 'postgresql-devel',
    }
  }
  package{'postgresql_client':
    ensure  => installed,
    name    => $operatingsystem ? {
      Ubuntu  => "postgresql-client-${version}",
      default => 'postgresql-client',
    }
  }

}
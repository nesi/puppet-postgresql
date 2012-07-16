class postgresql::server(
  $version = '9.1',
  $listen_addresses = 'localhost',
  $max_connections = 100,
  $shared_buffers = '24MB'
  ) {
  case $operatingsystem {
    Ubuntu: {
      class{'postgresql::server::install':
        version => $version,
        listen_addresses => $listen_addresses,
        max_connections => $max_connections,
        shared_buffers => $shared_buffers,
      }
    }
    default: {
      warning("PostgreSQL not configred for $operatingsystem")
    }
  }
}


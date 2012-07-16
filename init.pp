# Manifest for installing PostgreSQL in NeVE
# Used https://github.com/uggedal/puppet-module-postgresql as a template

class postgresql(
  $version = '9.1',
  $listen_addresses = 'localhost',
  $max_connections = 100,
  $shared_buffers = '24MB'
  ) {
  case $operatingsystem {
    Ubuntu: {
      class{'postgresql::server':
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

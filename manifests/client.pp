class postgresql::client(
  $version = '9.1'
){
  case $operatingsystem {
    Ubuntu:{
      class{'postgresql::client::install':
        version => $version,
      }
    }
    default: {
      warning("postgresql client not configured for ${operatingsystem}")
    }
  }
}
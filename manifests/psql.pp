# Executes a posgres SQL statement
#
# Without a password assumes that the $user is a user account locally
# and is authorised to use the postgresql database on the host
# Consider using ssh keys from auth.pp?
#
# Mostly copied from https://github.com/KrisBuytaert/puppet-postgres/blob/master/manifests/init.pp

define postgresql::psql(
  $user       = 'postgres',
  $host       = 'localhost',
  $password   = false,
  $database,
  $sql,
  $sqlcheck,
  $timeout    = 600,
  $logoutput  = false
){

  # There should be some sanity check on $sql and $sql check here

  # NOTE: The sqlcheck commands are specifically set up so
  # they can end in a > test or | grep, and must return 0 exit codes

  if $password == false {
    exec{"psql ${database} -c \"${sql}\" 2>&1 && sleep 5" :
      user        => $user,
      path        => ['/usr/bin','/bin'],
      timeout     => $timeout,
      logoutput   => $logoutput,
      unless      => "psql ${database} -c ${sqlcheck}",
      require     =>  Package['postgresql_client'],
    }
  } else {
    exec{"psql -U ${user} ${database} -c \"${sql}\" 2>&1 && sleep 5" :
      path        => ['/usr/bin','/bin'],
      environment => "PGPASSWORD=${password}",
      timeout     => $timeout,
      logoutput   => $logoutput,
      unless      => "psql -U ${username} ${database} -c ${sqlcheck}",
      require     => Package['postgresql_client'],
    }
  }
}
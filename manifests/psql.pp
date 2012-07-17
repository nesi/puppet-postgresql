# Executes a posgres SQL statement
#
# This assumes that the $user is a user account locally
# and is authorised to use the postgresql database on the host
# Consider using ssh keys from auth.pp?

define postgresql::psql(
  $host       = 'localhost',
  $user       = 'postgres',
  $password   = false,
  $database,
  $sql,
  $sqlcheck,
  $timeout    = 600
){

  # There should be some sanity check on $sql and $sql check here

  if $password {
    exec{"psql -h ${host} $database -c \"${sql}\" >> /var/lib/puppet/log/postgresql.sql.log 2>&1 && /bin/sleep 5":
      user        => $user,
      path        => ['/usr/bin'],
      timeout     => $timeout,
      unless      => "psql -h ${host} $database -c $sqlcheck",
      require     =>  Package['postgresql_client'],
    }
  } else {
    exec{"psql -h ${host} --username=${username} $database -c \"${sql}\" >> /var/lib/puppet/log/postgresql.sql.log 2>&1 && /bin/sleep 5":
      user        => $user,
      path        => ['/usr/bin'],
      environment => "PGPASSWORD=${password}",
      timeout     => $timeout,
      unless      => "psql -U $username $database -c $sqlcheck",
      require     => Package['postgresql_client'],
    }
  }
}
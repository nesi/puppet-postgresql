# This can only create a user on the PostgreSLQ server, and can not create users remotely
#
# Using checks from https://github.com/uggedal/puppet-module-postgresql/blob/master/manifests/user.pp

define postgres::createuser(
	$ensure 				= present,
	$user_password 	= false,
	$logoutput			= false
){
	if $ensure == 'present' {		
	  postgresql::psql{"createuser-${name}":
	    database 	=> "postgres",
	    sql      	=> "CREATE ROLE ${name} WITH LOGIN PASSWORD '${passwd}';",
	    sqlcheck 	=> "\"SELECT usename FROM pg_user WHERE usename = '${name}'\" | grep ${name}",
	    logoutput	=> $logoutput,
	    require  	=>  [Package['postgresql_client'],Service['postgresql']],
	  }
	} elsif $ensure == 'absent' {
		postgresql::psql{"destroyuser-${name}":
	    database 	=> "postgres",
	    sql      	=> "DROP ROLE ${name};",
	    sqlcheck 	=> "\"SELECT COUNT(*) FROM pg_catalog.pg_database JOIN pg_authid ON pg_catalog.pg_database.datdba = pg_authid.oid WHERE rolname = '${name}';\" --tuples-only --no-align | grep -e '^0$'",
	    logoutput	=> $logoutput,
	    require  	=>  [Package['postgresql_client'],Service['postgresql']],
	  }
	}
}
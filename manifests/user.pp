# This can only create a user on the PostgreSLQ server, and can not create users remotely
#
# Using checks from https://github.com/uggedal/puppet-module-postgresql/blob/master/manifests/user.pp
#
# DOES NOT MAKE SUPERUSERS. This is intentional. There can only be one.

define postgresql::user(
	$ensure 				= present,
	$password,
	$logoutput			= false
){

	# Should sanity check $name here

	if $ensure == 'present' {		
	  postgresql::psql{"createuser-${name}":
	    database 	=> "postgres",
	    sql      	=> "CREATE ROLE ${name} WITH LOGIN ENCRYPTED PASSWORD '${password}';",
	    sqlcheck 	=> "\"SELECT usename FROM pg_user WHERE usename = '${name}'\" | grep ${name}",
	    logoutput	=> $logoutput,
	    require  	=>  [Package['postgresql_client'],Service['postgresql']],
	  }
	} elsif $ensure == 'absent' {
		postgresql::psql{"destroyuser-${name}":
	    database 	=> "postgres",
	    sql      	=> "DROP ROLE ${name};",
	    sqlcheck 	=> "'SELECT rolname FROM pg_catalog.pg_roles;' |grep '^ ${name}$';if [ $? -eq 0 ]; then false; else true;fi;",
	    logoutput	=> $logoutput,
	    require  	=>  [Package['postgresql_client'],Service['postgresql']],
	  }
	}
}
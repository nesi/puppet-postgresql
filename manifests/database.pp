# Creates a database with $owner
# 
# Only runs on a PostgreSQL Server, does not run remotely... yet.


define postgresql::database(
	$ensure 		= present,
	$owner 			= 'postgres',
	$logoutput	= false
){

	# Should sanity check $name and $owner here

	if $ensure == present {
		postgresql::psql{"createdb-${name}":
	    database 	=> 'postgres',
	    logoutput	=> $logoutput,
	    sql      	=> "CREATE DATABASE ${name} WITH OWNER = ${owner};",
	    sqlcheck 	=> "\"SELECT datname FROM pg_database WHERE datname ='${name}'\" | grep ${name}",
	    require  	=> [Service['postgresql'],Postgresql::User[$owner]],
	  }
	} elsif $ensure == absent {
		postgresql::psql{"destroydb-${name}":
	    database 	=> 'postgres',
	    logoutput	=> $logoutput,
	    sql      	=> "DROP DATABASE ${name};",
	    sqlcheck 	=> "\"SELECT datname FROM pg_database WHERE datname ='${name}'\" | grep ${name};if [ $? -eq 0 ]; then false; else true;fi;",
	    require  	=> Service['postgresql'],
	  }
	}
}
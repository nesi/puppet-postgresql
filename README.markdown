# puppet-postgresql
===================

# Introduction

Yet another PostgreSQL module for puppet, but so far most of them seem incomplete.

The aim of this module is to provide:
* A paramaterised class to install the PostgreSQL service
* A paramaterised class to install the PostgreSQL client
* A resource definition for PostgreSQL databases
* A resource definition for PostgreSQL users (a.k.a roles)
* A resource definition for access rules in `pg_hba.conf`

# To install into puppet

Clone into your puppet configuration in your `puppet/modules` directory:

 git clone git://github.com/nesi/puppet-postgresql.git postgresql

Or if you're managing your Puppet configuration with git, in your `puppet` directory:

		git submodule add git://github.com/nesi/puppet-postgresql.git modules/postgresql --init --recursive
		cd modules/postgresql
		git checkout master
		git pull
		cd ../..
		git commit -m "added postgresql submodule from https://github.com/nesi/puppet-postgresql"

It might seem bit excessive, but it will make sure the submodule isn't headless...

# Using the PostgreSQL installer classes

Thes classes have been tested on Ubuntu 12.04 LTS, they do not have any other requirements.

## PostgreSQL installation with default settings

This will install the PostgreSQL service and the client with default settings on a puppet node:

		include potsgresql

## Install only the PostgreSQL client

With the default parameters:

		include postgresql::client

### Parameters for postgresql::client

* **version**: Specifies the version of the PostgreSQL client to be installed, defaults to '9.1'

## Install the PostgreSQL Service

**NOTE:** The resource definitions *require* that both the PostgreSQL server is installed with the client. This may be changed if there is a need to 'just' install the service and not use the resource definitions.

With the default parameters:

		include postgresql::server

## Parameters

* **version**: Specifies the PostgreSQL service version to install, defaults to '9.1'
* **listen_addresses**: Specifies a comma separated list of IP addresses and/or host names that the PostgreSQL service will listen on, defaults to 'localhost'
* **max_connections**: Specifies the maximum number of simultaneous connections, defaults to 100
* **shared_buffers**: Specifies the amount of memory to use in the shared buffers, defaults to '24MB'
* **psql_port**: Specifies the TCP port that the PostgreSQL service will listen on, defaults to '5432'

# Using the PostgreSQL resource definitions

These definitions have been tested on Ubuntu 12.04 LTS, they require the puppet::server class, which can be done in the node definition, or in another puppet module.

## PostgreSQL command definition

This defines a command to be execuded using the psql client on the server. Currently it runs locally on the PostgreSQL server. It's used as a wrapper around the `psql` client to in the other resource definitions in this module.

**NOTE:** To use this resource will need _two_ SQL statements, one that is to be executed, and second SQL check that returns a 0 exit code when the first statement should _not_ be run.

A minimal execution:

		postgresql::psql{"createuser-gort":
				sql      	=> "CREATE ROLE gort WITH LOGIN",
				sqlcheck 	=> "\"SELECT usename FROM pg_user WHERE usename = 'gort'\" | grep gort",
		}

### Parameters

* **user**: The PostgreSQL user running the command, defaults to 'postgres'
* **password**: The PostgreSQL user's password, which defaults to 'false' meaning use passwordless methods of accessing PostgreSQL.
* **host**: The host name of the PostgreSQL server, this defaults to 'localhost'. (not yet tested on remote database servers)
* **database**: This is tne name of the database to which the SQL statement is to be submitted to, defaults to 'postgres'
* **sql**: This is the SQL statement to be submitted, this is a required parameter and has no default. The statement will need to be a safe string, there are no sanity checks on SQL statements.
* **sqlcheck**: This is a SQL statement used to check if the statement given in the `sql` parameter should not be executed. This parameter is required and there is no default. This statement needs to include escaped quotes (e.g \"SELECT foo FROM baa\") and permits the addition of pipes at the end of the statement to test the statement's output. `| grep ${foo};if [ $? -eq 0 ]; then false; else true;fi;` is a useful construct for inverting the test's exit code as it's not possible to prefix `!` to a pipe.
* **timeout**: Changes the timeoute in seconds to wait for the sql and sqlcheck statements to complete, defaults to 600 seconds (10 minutes).
* **logoutput**: If set to 'true' this will log output to the Puppet logs, defaults to 'false'.

## PostgreSQL Database definition

### Parameters

## PostgreSQL User definition

Maybe this definition should be 'role', or have an alias...

### Parameters

## PostgreSQL access rules for `pg_hba.conf` definition

## Parameters

# To do...

* have the psql command definition excute on remote PostgreSQL servers, it should, but it hasn't been tested.
* Check that sql and sqlcheck statements are sane and safe.

# References

This module has used snippets from  the following puppet-postgresql projects:
* https://github.com/uggedal/puppet-module-postgresql 
* https://github.com/KrisBuytaert/puppet-postgres
* https://github.com/inkling/puppet-postgresql

These were all good, but didn't meet all our requirements.

# Licensing

Written by Aaron Hicks (hicksa@landcareresearch.co.nz) for the New Zealand eScience Infrastructure.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/"><img alt="Creative Commons Licence" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>

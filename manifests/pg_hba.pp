# Manifest for managing pg_hba entries
# no currently operational!

# If you need it later, code it later.

define postgresql::pg_hba(
	$ensure				= present,
	$type					= 'local',
	$databases		= ['all'],
	$user 				= 'all',
	$host					= false,
	$auth_method	= 'md5'
){

	if ! ($auth_method in ['md5','trust','reject','peer','password']) {
		$error_msg = "The authorisation METHOD '${auth_method}' is not supported in postgresql::pg_hba on ${fqdn}."
	}

	$db_string = inline_template("<%= databases.join(',') %>")

	if ! $error_msg {
		case $type {
			local:{
				$pg_hba_line = "${type} 	${db_string} 	${user} 			${auth_method}"
			}
			host:{
				$pg_hba_line = "${type} 	${db_string} 	${user} 	${host} 	${auth_method}"
			}
			default:{
				$error_msg = "The TYPE '${type}' is not supported in postgresql::pg_hba on ${fqdn}"
			}
		}
	}

	if ! $error_msg {
		file_line{'${type}_${user}_${auth_method}_pghba':
			ensure		=> $ensure,
			line 			=> $pg_hba_line,
			path 			=> "/etc/postgresql/${postgresql::server::version}/main/pg_hba.conf",
			notify		=> Service['postgresql'],
		}
	} else {
		err($error_msg)
	}

}
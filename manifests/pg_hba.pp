# Manifest for managing pg_hba entries
# no currently operational!

# If you need it later, code it later.

define postgresql::pg_hba(
	$ensure				= present,
	$type					= 'local',
	$databases		= ['all'],
	$user,
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
			default:{
				$error_msg = "The TYPE '${type}' is not supported in postgresql::pg_hba on ${fqdn}"
			}
		}
	}

	if ! $error_msg {
		# Insert line into pg_hba here!
	} else {
		err($error_msg)
	}

}
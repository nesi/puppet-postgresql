# Manifest for installing PostgreSQL in NeVE
# Used https://github.com/uggedal/puppet-module-postgresql as a template
# installs the postgresql server and postgresql client with default settings!

class postgresql {
  include postgresql::server
  include postgresql::client
}

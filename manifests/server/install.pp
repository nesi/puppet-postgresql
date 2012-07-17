class postgresql::server::install(
  $version,
  $listen_addresses,
  $max_connections,
  $shared_buffers
  ) {

  package {"postgresql":
    ensure  => present,
    name    => $operatingsystem ? {
      Ubuntu  => "postgresql-${version}",
      default => "postgresql",
    },
  }

  package {'postgresql-plperl':
    ensure  => installed,
    require => Package['postgresql'],
    name    => $operatingsystem ? {
      Ubuntu  => "postgresql-plperl-${version}",
      default => "postgresql-plperl",
    },
  }

  package {'postgresql-contrib':
    ensure  => installed,
    require => Package['postgresql'],
    name    => $operatingsystem ?{
      Ubuntu  => "postgresql-contrib-${version}",
      default => 'postgresql-contrib',
    }
  }

  service {'postgresql':
    enable      => true,
    name        => 'postgresql',
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package['postgresql'],
  }

  user { 'postgres':
    ensure  => present,
    require => Package['postgresql'],
  }

  file {"pg_hba.conf":
    path    => "/etc/postgresql/${version}/main/pg_hba.conf",
    source  => [
      "puppet:///modules/postgresql/${version}/${fqdn}/pg_hba.conf",
      "puppet:///modules/postgresql/${version}/${operatingsystem}/pg_hba.conf",
      "puppet:///modules/postgresql/${version}/pg_hba.conf",
      "puppet:///modules/postgresql/pg_hba.conf",
    ],
    mode    => 640,
    require => [Package['postgresql'],User['postgres']],
    notify  => Service['postgresql'],
    owner   => 'postgres',
    group   => 'postgres',
  }

  file {"postgresql.conf":
    path    => "/etc/postgresql/${version}/main/postgresql.conf",
    content => template("postgresql/${version}/postgresql.conf.erb"),
    require => Package['postgresql'],
    notify  => Service['postgresql'],
  }

  $foo = File['postgresql.conf']['path']

  warning("Does this work: ${foo}")
}  


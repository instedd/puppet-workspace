node "puppet-client.local" {
  class { 'rbenv': }
  rbenv::plugin { 'sstephenson/ruby-build': }
  # rbenv::build { '2.0.0-p247':
  #   global => true
  # }

  class { 'apache': }

  apt::source { 'passenger':
    location => 'https://oss-binaries.phusionpassenger.com/apt/passenger',
    key => '561F9B9CAC40B2F7'
  }
  ->
  package { "libapache2-mod-passenger":
    ensure => installed
  }

}

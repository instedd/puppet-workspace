define application (
  $appdir = "/u/apps/$name",
  $source = undef,
  $revision = undef
) {

  file { ["/u", "/u/apps", $appdir, "$appdir/shared", "$appdir/releases"]:
      ensure => directory;
  }

  vcsrepo { "$appdir/shared/cached-copy":
    ensure => present,
    provider => git,
    source => $source,
    revision => $revision,
    require => File["$appdir/shared"],
  }

  file {"$appdir/releases/$revision":
    ensure => directory,
    source => "$appdir/shared/cached-copy",
    recurse => true,
    replace => true,
    show_diff => false,
    backup => false,
    require => [File["$appdir/releases"], Vcsrepo["$appdir/shared/cached-copy"]]
  }

  file {"$appdir/current":
    ensure => link,
    target => "$appdir/releases/$revision",
    require => File["$appdir/releases/$revision"]
  }

}

# Class: nuntium
#
#
class nuntium inherits application {

}

node "resmap.local" {
  # class { 'resourcemap':
  #   deploy_user => 'vagrant'
  # }

  # Define: application
  # Parameters:
  #
  #

  class { 'rbenv': }
  rbenv::plugin { 'sstephenson/ruby-build': }
  rbenv::build { '1.9.3-p484': global => true }

  application { 'nuntium':
    appdir => '/u/apps/nuntium',
    source => 'https://bitbucket.org/instedd/nuntium',
    revision => '999de3110984b32cfdf6ae1e093106a84e03afc4',
    require => Rbenv::Build['1.9.3-p484']
  }

  $nuntium_appdir = getparam(Application['nuntium'], 'appdir')
  $nuntium_revision = getparam(Application['nuntium'], 'revision')

  notice("appdir = $nuntium_appdir")

  ensure_packages ["libmysqlclient-dev"]

  exec { 'nuntium.bundle.install':
    cwd => "$nuntium_appdir/releases/$nuntium_revision",
    command => "$::rbenv::install_dir/shims/bundle --gemfile='$nuntium_appdir/releases/$nuntium_revision/Gemfile' --path='$nuntium_appdir/shared/bundle'",
    subscribe => Application['nuntium'],
    logoutput => on_failure,
    timeout => 0,
    unless => "$::rbenv::install_dir/shims/bundle check --gemfile='$nuntium_appdir/releases/$nuntium_revision/Gemfile' --path='$nuntium_appdir/shared/bundle'"
  }

}

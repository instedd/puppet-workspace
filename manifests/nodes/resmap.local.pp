node "resmap.local" {
  class { 'resourcemap':
    deploy_user => 'vagrant'
  }
}

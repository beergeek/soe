# Class: soe
# ===========================
#
# A Class to manage a MCO agent for checking SOE resources.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `enable_agent`
#  Have a `true` for nodes.
#
# * `enable_app`
#  Have a `true` on MCO client and `false` on all others
#
#
# Examples
# --------
#
# @example
#    class { 'soe':
#      enable_agent => true,
#      enable_app   => false,
#    }
#
#
# @example
#   # note types of quotes for `resource_hash`
#   mco soe_check --resource_hash='{"file" => ["/etc","/tmp"],"user" => ["root","ftp"]}'
#
# Authors
# -------
#
# Author Name <brett@puppet.com>
#
# Copyright
# ---------
#
# Copyright 2017 Brett Gray, unless otherwise noted.
#
class soe (
  Boolean $enable_agent = true,
  Boolean $enable_app   = false,
) {

  if $::os['name'] == 'windows' {
    File {
      owner => 'S-1-5-32-544',
      group => 'S-1-5-32-544',
      mode  => '0644',
    }
    $mco_dir = 'C:/ProgramData/puppetlabs/mcollective/plugins/mcollective'
  } else {
    File {
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }
    $mco_dir = '/opt/puppetlabs/mcollective/plugins/mcollective'
  }
  $mco_svc = 'mcollective'

  if $enable_agent or $enable_app {
    $dll_ensure = file
  } else {
    $dll_ensure = absent
  }
  if $enable_agent {
    $agent_ensure = file
  } else {
    $agent_ensure = absent
  }
  if $enable_app {
    $app_ensure = file
  } else {
    $app_ensure = absent
  }

  file { "${mco_dir}/agent/soe.ddl":
    ensure => $dll_ensure,
    source => 'puppet:///modules/soe/soe_agent.ddl',
    notify => Service[$mco_svc],
  }

  file { "${mco_dir}/agent/soe.rb":
    ensure => $agent_ensure,
    source => 'puppet:///modules/soe/soe_agent.rb',
    notify => Service[$mco_svc],
  }

  file { "${mco_dir}/application/soe_check.rb":
    ensure => $app_ensure,
    source => 'puppet:///modules/soe/soe_app.rb',
  }
}

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
  Bool $enable_agent = true,
  Bool $enable_app   = false,
) {

  if $::os['name'] == 'windows' {
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
  }

  if $enable_agent or $enable_app {
    file { "${mco_dir}/agent/soe.ddl":
      ensure => file,
      source => 'puppet:///modules/soe/soe_agent.ddl',
      notify => Service[$mco_svc],
    }
  }

  if $enable_agent {
    file { "${mco_dir}/agent/soe.rb":
      ensure => file,
      source => 'puppet:///modules/soe/soe_agent.rb',
      notify => Service[$mco_svc],
    }
  }

  if $enable_app {
    file { "${mco_dir}/application/soe_check.rb":
      ensure => file,
      source => 'puppet:///modules/soe/soe_app.rb',
    }
  }




}

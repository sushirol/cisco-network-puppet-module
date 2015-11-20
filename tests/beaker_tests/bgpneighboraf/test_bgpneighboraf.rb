###############################################################################
# Copyright (c) 2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################
# TestCase Name:
# -------------
# test-bgpneighboraf.rb
#
# TestCase Prerequisites:
# -----------------------
# This is a Puppet BGP Neighbor AF resource testcase for Puppet Agent on
# Nexus devices.
# The test case assumes the following prerequisites are already satisfied:
#   - Host configuration file contains agent and master information.
#   - SSH is enabled on the N9K Agent.
#   - Puppet master/server is started.
#   - Puppet agent certificate has been signed on the Puppet master/server.
#
# TestCase:
# ---------
# This BGP Neighbor AF resource test verifies default values for all properties.
#
# The following exit_codes are validated for Puppet, Vegas shell and
# Bash shell commands.
#
# Vegas and Bash Shell Commands:
# 0   - successful command execution
# > 0 - failed command execution.
#
# Puppet Commands:
# 0 - no changes have occurred
# 1 - errors have occurred,
# 2 - changes have occurred
# 4 - failures have occurred and
# 6 - changes and failures have occurred.
#
# NOTE: 0 is the default exit_code checked in Beaker::DSL::Helpers::on() method.
#
# The test cases use RegExp pattern matching on stdout or output IO
# instance attributes to verify resource properties.
#
###############################################################################
# rubocop:disable Style/HashSyntax
require File.expand_path('../../lib/utilitylib.rb', __FILE__)

# -----------------------------
# Common settings and variables
# -----------------------------
testheader = 'Resource cisco_bgp_neighbor_af'

# Define PUPPETMASTER_MANIFESTPATH.
UtilityLib.set_manifest_path(master, self)

# The 'tests' hash is used to define all of the test data values and expected
# results. It is also used to pass optional flags to the test methods when
# necessary.

# 'tests' hash
# Top-level keys set by caller:
# tests[:master] - the master object
# tests[:agent] - the agent object
#
tests = {
  master:               master,
  agent:                agent,
  default_value_tests:  {
    'IPv4 Unicast' => {
      title_pattern: '2 default 1.1.1.1 ipv4 unicast',
      inputs:        {
	'allowas_in'                  => 'default',
        'allowas_in_max'              => 'default',
        'default_originate'           => 'default',
        'default_originate_route_map' => 'default',
        'disable_peer_as_check'       => 'default',
        'max_prefix_limit'            => 'default',
        'max_prefix_threshold'        => 'default',
        'max_prefix_interval'         => 'default',
        'next_hop_self'               => 'default',
        'next_hop_third_party'        => 'default',
        'route_reflector_client'      => 'default',
        'send_community'              => 'default',
        'suppress_inactive'           => 'default',
        'unsuppress_map'              => 'default',
        'weight'                      => 'default',
      },
      outputs:       {
        'additional_paths_receive' => 'inherit',
        'additional_paths_send'    => 'inherit',
        'allowas_in'               => 'false',
        'allowas_in_max'           => '3',
        'as_override'              => 'false',
        'default_originate'        => 'false',
        'disable_peer_as_check'    => 'false',
        'next_hop_self'            => 'false',
        'next_hop_third_party'     => 'true',
        'route_reflector_client'   => 'false',
        'send_community'           => 'none',
        'soft_reconfiguration_in'  => 'inherit',
        'suppress_inactive'        => 'false',
      },
    },
    'L2VPN' => {
      title_pattern: '2 default 1.1.1.1 l2vpn evpn',
      inputs:        {
        'allowas_in'                  => 'default',
        'allowas_in_max'              => 'default',
        'disable_peer_as_check'       => 'default',
        'max_prefix_limit'            => 'default',
        'max_prefix_threshold'        => 'default',
        'max_prefix_interval'         => 'default',
        'route_reflector_client'      => 'default',
        'send_community'              => 'default',
      },
      outputs:       {
        'allowas_in'              => 'false',
        'allowas_in_max'          => '3',
        'disable_peer_as_check'   => 'false',
        'route_reflector_client'  => 'false',
        'send_community'          => 'none',
        'soft_reconfiguration_in' => 'inherit',
      },
    },
  },
  explicit_value_tests: {
    'IPv4 Unicast' => {
      title_pattern: '2 blue 1.1.1.1 ipv4 unicast',
      values: [
        {
          'allowas_in' => true,
          'allowas_in_max' => 5,
        },
        {
          'additional_paths_receive' => 'disable',
          'additional_paths_send'    => 'disable',
        },
        {
          'additional_paths_receive' => 'enable',
          'additional_paths_send'    => 'enable',
        },
        {
          'default_originate'           => 'true',
          'default_originate_route_map' => 'my_def_map',
          'disable_peer_as_check'       => 'true',
        },
        {
          'max_prefix_interval'  => '30',
          'max_prefix_limit'     => '100',
          'max_prefix_threshold' => '50',
        },
        {
          'next_hop_self'        => 'true',
          'next_hop_third_party' => 'false',
        },
        {
          'send_community'    => 'extended',
          'suppress_inactive' => 'true',
          'unsuppress_map'    => 'unsup_map',
        },
        { 'soft_reconfiguration_in' => 'always' },
        { 'soft_reconfiguration_in' => 'enable' },
        { 'soo' => '3:3' },
        { 'weight' => '30' },
        {
          'advertise_map_exist' => ['admap', 'exist_map'],
          'filter_list_in'      => 'flin',
          'filter_list_out'     => 'flout',
          'prefix_list_in'      => 'pfx_in',
          'prefix_list_out'     => 'pfx_out',
          'route_map_in'        => 'rm_in',
          'route_map_out'       => 'rm_out',
        },
        { 'advertise_map_non_exist' => ['admap', 'non_exist_map'] },
      ],
    },
    'L2VPN EVPN'   => {
      title_pattern: '2 default 1.1.1.1 l2vpn evpn',
      values:        [
        {
          'allowas_in' => true,
          'allowas_in_max' => 5,
        },
        {
          'max_prefix_interval'  => '30',
          'max_prefix_limit'     => '100',
          'max_prefix_threshold' => '50',
        },
        { 'send_community' => 'extended' },
        { 'soft_reconfiguration_in' => 'always' },
        { 'soft_reconfiguration_in' => 'enable' },
        {
          'filter_list_in'  => 'flin',
          'filter_list_out' => 'flout',
          'prefix_list_in'  => 'pfx_in',
          'prefix_list_out' => 'pfx_out',
          'route_map_in'    => 'rm_in',
          'route_map_out'   => 'rm_out',
        },
      ],
    },
    'EBGP'         => {
      title_pattern: '2 yellow 3.3.3.3 ipv4 unicast',
      remote_as:     '2 yellow  3.3.3.3 3',
      values:        [
        { 'as_override' => 'true' },
      ],
    },
    'IBGP'         => {
      title_pattern: '2 green 2.2.2.2 ipv4 unicast',
      remote_as:     '2 green  2.2.2.2 2',
      values:        [
        { 'route_reflector_client' => 'true' },
      ],
    },
    'IBGP L2VPN'   => {
      title_pattern: '2 default 2.2.2.2 l2vpn evpn',
      remote_as:     '2 default  2.2.2.2 2',
      values:        [
        { 'route_reflector_client' => 'true' },
      ],
    },

  },
}


#################################################################
# HELPER FUNCTIONS
#################################################################

# Full command string for puppet resource with neighbor AF
def puppet_resource_cmd(af)
  cmd = UtilityLib::PUPPET_BINPATH + \
        "resource cisco_bgp_neighbor_af '#{af.values.join(' ')}'"
  UtilityLib.get_namespace_cmd(agent, cmd, options)
end

# Create actual manifest for a given test scenario.
def build_manifest_bgp_nbr_af(testcase, label)
  manifest = prop_hash_to_manifest(testcase[:af])
  if testcase[:ensure] == :absent
    state = 'ensure => absent,'
    testcase[:resource] = { 'ensure' => 'absent' }
  else
    state = 'ensure => present,'
    testcase[:inputs].each do |key, value|
      manifest += "\n#{key} => '#{value}',"
    end
    testcase[:resource] = testcase[:outputs]
  end

  testcase[:title_pattern] = label if testcase[:title_pattern].nil?
  logger.debug("build_manifest_bgp_nbr_af :: title_pattern:\n" +
               testcase[:title_pattern])
  testcase[:manifest] = "cat <<EOF >#{UtilityLib::PUPPETMASTER_MANIFESTPATH}
  node 'default' {
    cisco_bgp_neighbor_af { '#{testcase[:title_pattern]}':
      #{state}
      #{manifest}
    }
  }
EOF"
end

# Wrapper for bgp_nbr_af specific settings prior to calling the
# common test_harness.
def test_harness_bgp_nbr_af(tests)
  tests[:default_value_tests].each do |label, testcase|
    # TODO for title pattern tests
    af = bgp_title_pattern_munge_new(testcase, label, 'bgp_neighbor_af')
    logger.info("\n--------\nTest Case Address-Family ID: #{af}")

    # Set up remote-as if necessary
    bgp_nbr_remote_as(agent, testcase[:remote_as]) if testcase[:remote_as]

    testcase[:ensure] = :present if testcase[:ensure].nil?
    testcase[:resource_cmd] = puppet_resource_cmd(af)

    # Build the manifest for this test
    build_manifest_bgp_nbr_af(testcase, label)

    test_harness_common_new(testcase, label, tests)
    testcase[:ensure] = nil
  end

  # TODO: iterate over non_default_value_tests
  # TODO: title_pattern tests
end

#################################################################
# TEST CASE EXECUTION
#################################################################
test_name "TestCase :: #{testheader}" do
  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 1. Default Property Testing")
  node_feature_cleanup(agent, 'bgp')

  test_harness_bgp_nbr_af(tests)

=begin
  # -----------------------------------
  id = 'default_properties'
  test_harness_bgp_nbr_af(tests, id)

  tests[id][:ensure] = :absent
  test_harness_bgp_nbr_af(tests, id)

  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 2. Non Default Property Testing")
  node_feature_cleanup(agent, 'bgp')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_A1')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_A2')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_A3')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_D')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_M')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_N')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_S1')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_S2')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_S3')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_W')

  # Special Cases
  test_harness_bgp_nbr_af(tests, 'non_default_properties_ebgp_only')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_ibgp_only')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_vrf_only')
  test_harness_bgp_nbr_af(tests, 'non_default_misc_maps_part_1')
  test_harness_bgp_nbr_af(tests, 'non_default_misc_maps_part_2')

  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 3. Title Pattern Testing")
  node_feature_cleanup(agent, 'bgp')

  id = 'title_patterns'
  tests[id][:desc] = '3.1 Title Patterns'
  tests[id][:title_pattern] = '2'
  tests[id][:af] = { :neighbor => '1.1.1.1',
                     :afi => 'ipv4', :safi => 'unicast' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '3.2 Title Patterns'
  tests[id][:title_pattern] = '2 blue'
  tests[id][:af] = { :neighbor => '2.2.2.2', :afi => 'ipv4',
                     :safi => 'unicast' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '3.3 Title Patterns'
  tests[id][:title_pattern] = '2 green 3.3.3.3'
  tests[id][:af] = { :afi => 'ipv4', :safi => 'unicast' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '3.4 Title Patterns'
  tests[id][:title_pattern] = '2 red 4.4.4.4 ipv4'
  tests[id][:af] = { :safi => 'unicast' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '3.5 Title Patterns'
  tests[id][:title_pattern] = '2 yellow 5.5.5.5 ipv4 unicast'
  tests[id].delete(:af)
  test_harness_bgp_nbr_af(tests, id)

  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 4. L2VPN Default Property Testing")
  node_feature_cleanup(agent, 'bgp')

  # -----------------------------------
  id = 'default_properties_l2vpn'
  test_harness_bgp_nbr_af(tests, id)

  tests[id][:ensure] = :absent
  test_harness_bgp_nbr_af(tests, id)

  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 5. L2VPN  Non Default Property Testing")
  node_feature_cleanup(agent, 'bgp')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_A1_l2vpn')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_M_l2vpn')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_S1_l2vpn')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_S2_l2vpn')
  test_harness_bgp_nbr_af(tests, 'non_default_properties_S3_l2vpn')

  # Special Cases
  test_harness_bgp_nbr_af(tests, 'non_default_properties_ibgp_only_l2vpn')
  test_harness_bgp_nbr_af(tests, 'non_default_misc_maps_part_1_l2vpn')
=end


# TODO
=begin
  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 6. L2VPN Title Pattern Testing")
  node_feature_cleanup(agent, 'bgp')

  id = 'title_patterns'
  tests[id][:desc] = '6.1 Title Patterns'
  tests[id][:title_pattern] = '2'
  tests[id][:af] = { :neighbor => '1.1.1.1',
                     :afi => 'l2vpn', :safi => 'evpn' }
  test_harness_bgp_nbr_af(tests, id)
  # -----------------------------------
  tests[id][:desc] = '6.2 Title Patterns'
  tests[id][:title_pattern] = '2 default'
  tests[id][:af] = { :neighbor => '2.2.2.2', :afi => 'l2vpn',
                     :safi => 'evpn' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '6.3 Title Patterns'
  tests[id][:title_pattern] = '2 default 6.3.3.3'
  tests[id][:af] = { :afi => 'l2vpn', :safi => 'evpn' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '6.4 Title Patterns'
  tests[id][:title_pattern] = '2 default 4.4.4.4 l2vpn'
  tests[id][:af] = { :safi => 'evpn' }
  test_harness_bgp_nbr_af(tests, id)

  # -----------------------------------
  tests[id][:desc] = '6.5 Title Patterns'
  tests[id][:title_pattern] = '2 default 5.5.5.5 l2vpn evpn'
  tests[id].delete(:af)
  test_harness_bgp_nbr_af(tests, id)
=end
end

logger.info("TestCase :: #{testheader} :: End")

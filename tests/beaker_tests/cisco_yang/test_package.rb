###############################################################################
# Copyright (c) 2016 Cisco and/or its affiliates.
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
#
# See README-develop-beaker-scripts.md (Section: Test Script Variable Reference)
# for information regarding:
#  - test script general prequisites
#  - command return codes
#  - A description of the 'tests' hash and its usage
#
###############################################################################
require File.expand_path('../../lib/utilitylib.rb', __FILE__)

# Test hash top-level keys
tests = {
  master:        master,
  agent:         agent,
  ensurable:     true,
  resource_name: 'cisco_yang',
}

tests[:install] = {
  desc:           'Beaker Test',
  title_pattern:  '{"Cisco-IOS-XR-infra-rsi-cfg:vrfs": [null]}',
  manifest_props: {
    #ensure:             'present',
    source: '{"Cisco-IOS-XR-infra-rsi-cfg:vrfs":{"vrf":{"vrf-name":"blue", "create":[null]}}}',
  },
  resource:       {
    'ensure' => 'present',
  },
}

#################################################################
# TEST CASE EXECUTION
#################################################################
test_name "TestCase :: Source Present" do

  # -------------------------------------------------------------------
  logger.info("\n#{'-' * 60}\nSection 1. sample test")
  id = :install
  #tests[id][:code] = [0, 2]
  test_harness_run(tests, id)
  logger.info("\n#{'-' * 60}\nTest Complete")
  skipped_tests_summary(tests)
  # -------------------------------------------------------------------
end

logger.info("TestCase :: #{tests[:resource_name]} :: End")

#!/usr/bin/env bash

Describe 'Core Functions'
Include ./tests/unit/test_helper.sh

BeforeEach 'setup'
AfterEach 'teardown'

Describe 'Config Management'
It 'should set and get config values'
When call set_config "key" "value"
The status should be success

When call get_config "key"
The output should eq "value"
End

It 'should handle missing config values'
When call get_config "nonexistent"
The status should be success
The output should eq ""
End

It 'should update existing config values'
When call set_config "key" "value"
The status should be success

When call set_config "key" "new-value"
The status should be success

When call get_config "key"
The output should eq "new-value"
End
End

Describe 'Uninstall Process'
It 'should remove configuration files when confirmed'
# Mock read command to simulate user input
Mock read
echo "y"
End

# Create test config files
touch "$TEST_CONFIG_DIR/config"
touch "$TEST_DATA_DIR/data"
touch "$TEST_CACHE_DIR/cache"

When call cleanup_config
The status should be success
The dir "$TEST_CONFIG_DIR" should not exist
The dir "$TEST_DATA_DIR" should not exist
The dir "$TEST_CACHE_DIR" should not exist
End
End
End

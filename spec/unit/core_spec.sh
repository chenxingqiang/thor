#!/usr/bin/env bash

Describe 'Core Functions'
Include lib/core/config.sh

BeforeEach 'setup_test_env'
AfterEach 'cleanup_test_env'

Describe 'Config Management'
It 'should set and get config values'
When call set_config "test.key" "value"
The status should be success

When call get_config "test.key"
The output should eq "value"
End

It 'should handle missing config values'
When call get_config "missing.key"
The output should eq ""
End

It 'should update existing config values'
When call set_config "test.key" "value"
The status should be success

When call set_config "test.key" "new-value"
The status should be success

When call get_config "test.key"
The output should eq "new-value"
End
End
End

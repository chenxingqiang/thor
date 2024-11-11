Describe 'Core Utils'
Include lib/core/utils.sh

BeforeEach 'setup_test_env'
AfterEach 'cleanup_test_env'

Describe 'Cache Management'
It 'can set and get cache values'
When call set_cache "test.key" "test-value"
The status should be success

When call get_cache "test.key"
The output should eq "test-value"
End

It 'can clear specific cache key'
When call set_cache "test.key" "test-value"
The status should be success

When call clear_cache "test.key"
The status should be success

When call get_cache "test.key"
The output should eq ""
End
End
End

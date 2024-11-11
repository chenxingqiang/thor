Describe 'Utils'
Include lib/core/utils.sh

Describe 'is_valid_identifier()'
It 'validates correct identifiers'
When call is_valid_identifier 'valid-name'
The status should be success
End

It 'rejects invalid identifiers'
When call is_valid_identifier '123-invalid'
The status should be failure
End
End

Describe 'find_available_port()'
It 'finds an available port'
When call find_available_port
The output should match pattern '[0-9]+'
The status should be success
End
End

Describe 'get_os()'
It 'detects operating system'
When call get_os
The output should not be empty
The status should be success
End
End
End

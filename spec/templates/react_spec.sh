Describe 'React Template'
Include lib/templates/project/react/scaffold.sh

BeforeEach 'setup_test_env'
AfterEach 'cleanup_test_env'

Describe 'Project Scaffolding'
It 'creates project structure'
TEST_PROJECT="test-project"

When call create_project_structure "$TEST_PROJECT"
The status should be success
The path "$TEST_PROJECT/src/components" should be directory
The path "$TEST_PROJECT/src/hooks" should be directory
The path "$TEST_PROJECT/src/pages" should be directory
End

It 'replaces template variables'
TEST_FILE="${TEST_DIR}/test.json"
echo '{"name":"{{name}}"}' >"$TEST_FILE"

When call replace_variables "$TEST_FILE" "test-project"
The contents of file "$TEST_FILE" should include "test-project"
End
End
End

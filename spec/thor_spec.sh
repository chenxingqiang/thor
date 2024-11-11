Describe 'thor command'
Include lib/core/utils.sh

Describe 'version'
It 'shows version'
When call thor --version
The output should match pattern 'thor version *'
The status should be success
End
End

Describe 'project initialization'
It 'creates a new react project'
When call thor init react test-project
The path 'test-project' should be directory
The path 'test-project/package.json' should be file
The status should be success
End

It 'creates a new vue project'
When call thor init vue test-vue
The path 'test-vue' should be directory
The path 'test-vue/package.json' should be file
The status should be success
End
End

Describe 'template management'
It 'lists available templates'
When call thor template list
The output should include 'Available templates'
The status should be success
End

It 'creates a new template'
When call thor template create test-template -t component
The path "$THOR_TEMPLATE_DIR/component/test-template" should be directory
The status should be success
End
End

Describe 'git utilities'
It 'generates gitignore'
When call thor git ignore node
The path '.gitignore' should be file
The content of file '.gitignore' should include 'node_modules'
The status should be success
End
End
End

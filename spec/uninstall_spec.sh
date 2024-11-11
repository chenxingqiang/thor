Describe 'uninstall.sh'
Include scripts/uninstall.sh

setup() {
    # Create temporary test directories
    TEST_HOME=$(mktemp -d)
    TEST_CONFIG="${TEST_HOME}/.config/thor"
    TEST_DATA="${TEST_HOME}/.local/share/thor"
    TEST_CACHE="${TEST_HOME}/.cache/thor"

    # Create test directories and files
    mkdir -p "$TEST_CONFIG" "$TEST_DATA" "$TEST_CACHE"
    mkdir -p "${TEST_HOME}/.bash_completion.d"
    mkdir -p "${TEST_HOME}/.zsh/completions"
    mkdir -p "${TEST_HOME}/.config/fish/completions"

    touch "${TEST_HOME}/.bash_completion.d/thor.bash"
    touch "${TEST_HOME}/.zsh/completions/_thor"
    touch "${TEST_HOME}/.config/fish/completions/thor.fish"
}

cleanup() {
    rm -rf "$TEST_HOME"
}

BeforeEach 'setup'
AfterEach 'cleanup'

Describe 'cleanup_config()'
It 'removes configuration directories when confirmed'
# Mock read command to simulate 'y' response
read() { REPLY='y'; }

When call cleanup_config
The status should be success
The path "$TEST_CONFIG" should not exist
The path "$TEST_DATA" should not exist
The path "$TEST_CACHE" should not exist
End

It 'keeps configuration directories when declined'
# Mock read command to simulate 'n' response
read() { REPLY='n'; }

When call cleanup_config
The status should be success
The path "$TEST_CONFIG" should exist
The path "$TEST_DATA" should exist
The path "$TEST_CACHE" should exist
End
End

Describe 'cleanup_completions()'
It 'removes all shell completion files'
When call cleanup_completions
The status should be success
The path "${TEST_HOME}/.bash_completion.d/thor.bash" should not exist
The path "${TEST_HOME}/.zsh/completions/_thor" should not exist
The path "${TEST_HOME}/.config/fish/completions/thor.fish" should not exist
End
End

Describe 'main()'
# Mock sudo to avoid actual system modifications
sudo() { echo "Would execute: $*"; }

It 'executes the complete uninstall process'
# Mock read command to simulate 'y' response
read() { REPLY='y'; }

When call main
The status should be success
The output should include "Uninstalling Thor..."
The output should include "Would execute: make uninstall"
The output should include "✅ Thor uninstalled successfully"
The path "$TEST_CONFIG" should not exist
The path "${TEST_HOME}/.bash_completion.d/thor.bash" should not exist
End
End
End

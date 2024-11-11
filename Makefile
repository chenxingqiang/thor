.PHONY: all install deps test lint clean install-local

# Default target
all: deps lint test

# Install dependencies
deps:
	@echo "Installing dependencies..."
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew is required. Please install it first."; exit 1; }
	@brew install shellcheck tree
	@brew install ruby
	@export PATH="/usr/local/opt/ruby/bin:$$PATH" && \
		gem install ronn mustache rdiscount hpricot --user-install

# Install thor locally and update PATH
install-local:
	@echo "Installing thor locally..."
	@mkdir -p ~/.local/bin
	@cp bin/thor ~/.local/bin/
	@chmod +x ~/.local/bin/thor
	@echo "Thor installed to ~/.local/bin"
	@echo "export PATH=\"$$HOME/.local/bin:$$PATH\"" >> ~/.bashrc
	@echo "export PATH=\"$$HOME/.local/bin:$$PATH\"" >> ~/.zshrc
	@export PATH="$$HOME/.local/bin:$$PATH"

# Test with PATH update
test: install-local
	@echo "Running tests..."
	@PATH="$$HOME/.local/bin:$$PATH" ./scripts/test.sh

# Lint shell scripts
lint:
	@echo "Linting shell scripts..."
	@# Only lint .sh files and shell scripts without extension
	@find . -type f \( -name "*.sh" -o -name "thor" \) \
		! -path "./completions/*" \
		! -path "./Formula/*" \
		! -path "./share/man/*" \
		! -path "./tests/integration/*" \
		! -path "./tests/unit/*" \
		-print0 | xargs -0 -n1 shellcheck --severity=warning

# Clean up
clean:
	@echo "Cleaning..."
	@rm -rf build/ dist/ ~/.local/bin/thor*


# 测试目标
.PHONY: test test-unit test-integration test-e2e

test: test-unit test-integration test-e2e

test-unit:
	@echo "Running unit tests..."
	@shellspec spec/unit/

test-integration:
	@echo "Running integration tests..."
	@shellspec spec/integration/

test-e2e:
	@echo "Running end-to-end tests..."
	@shellspec spec/e2e/

test-coverage:
	@echo "Running tests with coverage..."
	@SHELLSPEC_COVERAGE=1 shellspec
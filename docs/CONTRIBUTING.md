# Contributing to Thor

We love your input! We want to make contributing to Thor as easy and transparent as possible.

## Development Process

1. Fork the repo and create your branch from `main`
2. Make your changes following our coding guidelines
3. Test your changes thoroughly
4. Submit a pull request

## Project Structure

```
thor/
├── bin/           # CLI executables
├── lib/           # Core library code
│   ├── core/      # Core functionality
│   ├── templates/ # Template definitions
│   └── formatters/# Code formatters
├── tests/         # Test suites
└── docs/          # Documentation
```

## Development Setup

1. Clone your fork:

```bash
git clone git@github.com:YOUR_USERNAME/thor.git
cd thor
```

2. Install dependencies:

```bash
make deps
```

3. Run tests:

```bash
make test
```

## Coding Guidelines

### Shell Script Style

- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use shellcheck to lint your code
- Include comments for complex logic
- Write meaningful variable names

### Function Documentation

```bash
# Brief description of what the function does.
#
# Arguments:
#   $1 - description of first argument
#   $2 - description of second argument
#
# Options:
#   -f, --force    Force operation
#   -v, --verbose  Verbose output
#
# Returns:
#   0 on success, non-zero on error
#
# Example:
#   my_function "arg1" "arg2" --force
function my_function() {
    # Implementation
}
```

### Testing

- Write both unit and integration tests
- Test edge cases
- Include error cases
- Test both success and failure paths

## Creating Templates

1. Template Structure:

```
templates/
└── type/
    └── name/
        ├── template.json  # Template metadata
        ├── template.txt   # Template content
        └── scaffold.sh    # Optional scaffold script
```

2. Template JSON Schema:

```json
{
  "name": "template-name",
  "version": "1.0.0",
  "description": "Template description",
  "author": "Your Name",
  "variables": {
    "name": {
      "type": "string",
      "description": "Project name",
      "required": true
    }
  }
}
```

## Pull Request Process

1. Update documentation (if applicable)
2. Update tests
3. Update CHANGELOG.md
4. Update version numbers
5. Get review from maintainers

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description

[optional body]

[optional footer]
```

Types:

- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Formatting
- refactor: Code restructuring
- test: Adding tests
- chore: Maintenance

## Code Review

- All changes must be reviewed
- Address review comments
- Keep discussions focused

## Documentation

- Keep README.md up to date
- Document new features
- Include examples
- Update man pages

## Release Process

1. Update version in package.json
2. Update CHANGELOG.md
3. Create release branch
4. Run tests
5. Create release tag
6. Update Homebrew formula

## Getting Help

- Join our Discord server
- Check existing issues
- Ask in discussions

## Recognition

Contributors will be added to CONTRIBUTORS.md

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).

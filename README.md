# Project documentation
# Thor - Template Handler & Organizer

Thor is a powerful project scaffolding tool that helps you quickly create and manage project templates.

## Features

- 🚀 Quick project initialization
- 📦 Multiple template support
- 🔧 Customizable templates
- 🎯 Git integration
- 🎨 Code formatting
- 🛠 Multi-editor support (VSCode, Cursor)

## Installation

### Using Homebrew

```bash
brew install thor
```

### Manual Installation

```bash
git clone https://github.com/chenxingqiang/thor.git
cd thor
make install
```

## Quick Start

Create a new React project:
```bash
thor init react my-app
```

Create a new component:
```bash
thor create component Button.tsx -t react
```

Generate a .gitignore file:
```bash
thor git ignore node
```

## Template Management

List available templates:
```bash
thor template list
```

Create a new template:
```bash
thor template create my-template -t project
```

Install template from repository:
```bash
thor template install https://github.com/user/template
```

## Configuration

Thor can be configured through `~/.config/thor/config`:

```bash
# Editor preferences
PREFERRED_EDITOR="cursor"  # or "code", "vim"

# Template settings
DEFAULT_TEMPLATE="react"
CUSTOM_TEMPLATES_DIR="$HOME/.thor/templates"
```

## Available Templates

### Project Templates
- React (TypeScript + Tailwind)
- Next.js
- Vue
- Node.js

### Component Templates
- React Components
- Vue Components

### Git Templates
- Various .gitignore templates

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
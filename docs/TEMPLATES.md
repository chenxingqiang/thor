# Thor Templates Guide

This guide explains how to use and create templates in Thor.

## Available Templates

### Project Templates

#### React

- Modern React setup with TypeScript and Tailwind CSS
- Testing setup with Jest and React Testing Library
- ESLint and Prettier configuration
- GitHub Actions CI/CD

```bash
thor init react my-app
```

#### Next.js

- App Router configuration
- API routes setup
- TypeScript and Tailwind CSS
- Authentication ready
- Database setup (optional)

```bash
thor init next my-blog
```

#### Vue

- Vue 3 with Composition API
- TypeScript support
- Vite build tool
- Pinia state management
- Vitest testing setup

```bash
thor init vue my-store
```

### Component Templates

#### React Component

- TypeScript support
- Props interface
- Styling options
- Test file

```bash
thor create component Button.tsx -t react
```

#### Vue Component

- Script setup syntax
- TypeScript support
- Scoped styling
- Props validation
- Emits typing

```bash
thor create component BaseButton.vue -t vue
```

### Git Templates

Various .gitignore templates for different project types:

- Node.js
- Python
- Ruby
- Java
- Go

```bash
thor git ignore node
```

## Creating Custom Templates

### Template Structure

```
my-template/
├── template.json     # Template metadata
├── template.txt      # Main template content
├── scaffold.sh       # Setup script
└── templates/        # Additional template files
    ├── config/
    └── src/
```

### Template Configuration

```json
{
  "name": "my-template",
  "version": "1.0.0",
  "description": "Custom template description",
  "author": "Your Name",
  "variables": {
    "name": {
      "type": "string",
      "description": "Project name",
      "required": true
    },
    "description": {
      "type": "string",
      "default": "A new project"
    }
  },
  "files": {
    "ignore": ["node_modules", "dist"],
    "rename": {
      "gitignore": ".gitignore",
      "env.example": ".env"
    }
  },
  "hooks": {
    "pre-scaffold": "scripts/pre.sh",
    "post-scaffold": "scripts/post.sh"
  }
}
```

### Variable Substitution

Templates support variable substitution using handlebars-style syntax:

```typescript
interface {{name}}Props {
  title?: string;
  description?: string = "{{description}}";
}
```

### Installation

Install custom templates:

```bash
thor template install path/to/my-template
# or
thor template install https://github.com/user/template
```

### Testing Templates

Test your template:

```bash
thor template test my-template
```

## Template Best Practices

1. Keep templates focused
2. Document variables
3. Include tests
4. Use TypeScript
5. Follow style guides
6. Add error handling
7. Include examples
8. Update regularly

## Contributing Templates

1. Fork the repository
2. Create your template
3. Add documentation
4. Submit a pull request

## Template Repository

Visit our [template repository](https://github.com/thor/templates) for more templates.

## Need Help?

- Check our examples
- Join our Discord
- Open an issue

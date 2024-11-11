#!/usr/bin/env fish

# Fish shell completions for thor

# Define the main commands
complete -c thor -f
complete -c thor -n "__fish_use_subcommand" -a "init" -d "Initialize a new project"
complete -c thor -n "__fish_use_subcommand" -a "create" -d "Create a new component"
complete -c thor -n "__fish_use_subcommand" -a "template" -d "Manage templates"
complete -c thor -n "__fish_use_subcommand" -a "git" -d "Git related commands"

# Init command options
complete -c thor -n "__fish_seen_subcommand_from init" -l type -s t -d "Project type"
complete -c thor -n "__fish_seen_subcommand_from init" -a "(thor template list)"

# Create command options
complete -c thor -n "__fish_seen_subcommand_from create" -l type -s t -d "Component type"
complete -c thor -n "__fish_seen_subcommand_from create" -a "(thor template list-components)"

# Template command options
complete -c thor -n "__fish_seen_subcommand_from template" -a "list" -d "List available templates"
complete -c thor -n "__fish_seen_subcommand_from template" -a "create" -d "Create new template"
complete -c thor -n "__fish_seen_subcommand_from template" -a "install" -d "Install template"

# Git command options
complete -c thor -n "__fish_seen_subcommand_from git" -a "ignore" -d "Generate .gitignore"
complete -c thor -n "__fish_seen_subcommand_from git" -a "(thor git list-templates)"

# Global options
complete -c thor -l help -s h -d "Show help"
complete -c thor -l version -s v -d "Show version"

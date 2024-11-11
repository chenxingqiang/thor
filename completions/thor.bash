#!/usr/bin/env bash
# Bash command completion
_thor_completions() {
    local cur prev words cword
    _init_completion || return

    # Define main commands
    local commands="init template git create help version"

    # Define subcommands
    local template_commands="list create install remove update"
    local git_commands="ignore init clean"

    # Define project types
    local project_types="react next vue node"

    # Current command chain
    local cmd="${words[1]}"
    local subcmd="${words[2]}"

    # Handle main command completion
    if [ $cword -eq 1 ]; then
        mapfile -t COMPREPLY < <(compgen -W "${commands[*]}" -- "$cur")
        return 0
    fi

    # Handle subcommand completion based on main command
    case "$cmd" in
    template)
        if [ $cword -eq 2 ]; then
            mapfile -t COMPREPLY < <(compgen -W "${template_commands[*]}" -- "$cur")
            return 0
        fi
        case "$subcmd" in
        create | install | remove | update)
            if [ "$prev" = "-t" ] || [ "$prev" = "--type" ]; then
                mapfile -t COMPREPLY < <(compgen -W "project component git" -- "$cur")
                return 0
            fi
            mapfile -t COMPREPLY < <(compgen -W "-t --type -d --desc -f --force --global" -- "$cur")
            return 0
            ;;
        esac
        ;;
    git)
        if [ $cword -eq 2 ]; then
            mapfile -t COMPREPLY < <(compgen -W "${git_commands[*]}" -- "$cur")
            return 0
        fi
        case "$subcmd" in
        ignore)
            local gitignore_templates="node python ruby rails java"
            mapfile -t COMPREPLY < <(compgen -W "${gitignore_templates[*]}" -- "$cur")
            return 0
            ;;
        esac
        ;;
    init)
        if [ $cword -eq 2 ]; then
            mapfile -t COMPREPLY < <(compgen -W "${project_types[*]}" -- "$cur")
            return 0
        fi
        ;;
    esac

    # General option completion
    case "$prev" in
    -t | --template)
        mapfile -t COMPREPLY < <(compgen -W "${project_types[*]}" -- "$cur")
        return 0
        ;;
    -h | --help | -v | --version)
        return 0
        ;;
    esac

    # Default completion for files and directories
    _filedir
}

complete -F _thor_completions thor

#!/usr/bin/env zsh
# Zsh command completion
#compdef thor

_thor() {
    local -a commands
    local -a subcommands
    local -a options

    # 定义主命令
    commands=(
        'init:Initialize a new project'
        'template:Manage templates'
        'git:Git related utilities'
        'create:Create files from template'
        'help:Show help information'
        'version:Show version information'
    )

    # 定义子命令
    local -a template_commands=(
        'list:List available templates'
        'create:Create new template'
        'install:Install template from source'
        'remove:Remove template'
        'update:Update template'
    )

    local -a git_commands=(
        'ignore:Generate .gitignore file'
        'init:Initialize git repository'
        'clean:Clean git repository'
    )

    # 定义项目类型
    local -a project_types=(
        'react:React project'
        'next:Next.js project'
        'vue:Vue project'
        'node:Node.js project'
    )

    # 通用选项
    options=(
        '--help[Show help information]'
        '--version[Show version information]'
        '--force[Force operation]'
        '--global[Use global configuration]'
    )

    # 主命令补全
    _arguments -C \
        '1: :->command' \
        '2: :->subcommand' \
        '*:: :->option'

    case $state in
        command)
            _describe 'command' commands
            ;;
        subcommand)
            case $words[1] in
                template)
                    _describe 'template command' template_commands
                    ;;
                git)
                    _describe 'git command' git_commands
                    ;;
                init)
                    _describe 'project type' project_types
                    ;;
            esac
            ;;
        option)
            case $words[1] in
                template)
                    case $words[2] in
                        create|install|remove|update)
                            options+=(
                                '-t[Template type]:type:(project component git)'
                                '--type[Template type]:type:(project component git)'
                                '-d[Description]:description'
                                '--desc[Description]:description'
                            )
                            ;;
                    esac
                    ;;
                git)
                    case $words[2] in
                        ignore)
                            _values 'template' node python ruby rails java
                            ;;
                    esac
                    ;;
            esac
            _arguments $options
            ;;
    esac
}

compdef _thor thor
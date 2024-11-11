#!/usr/bin/env bash

set -e

# 获取变量
NAME="${1}"
DESCRIPTION="${2:-A React project created with Thor}"
AUTHOR="${3:-$(git config user.name)}"
VERSION="${4:-0.1.0}"

# 检查必需工具
check_requirements() {
    command -v node >/dev/null 2>&1 || {
        echo "Error: node is required but not installed"
        exit 1
    }

    command -v pnpm >/dev/null 2>&1 || {
        echo "Installing pnpm..."
        npm install -g pnpm
    }
}

# 创建项目结构
create_project_structure() {
    mkdir -p "$NAME"/{src/{components,hooks,pages,styles,utils},public}

    # 复制模板文件
    cp -r template/* "$NAME/"

    # 重命名特殊文件
    mv "$NAME/gitignore" "$NAME/.gitignore"
    mv "$NAME/env.example" "$NAME/.env"

    # 替换模板变量
    replace_variables "$NAME/package.json"
    replace_variables "$NAME/README.md"
}

# 替换模板变量
replace_variables() {
    local file="$1"
    sed -i '' \
        -e "s|{{name}}|$NAME|g" \
        -e "s|{{description}}|$DESCRIPTION|g" \
        -e "s|{{author}}|$AUTHOR|g" \
        -e "s|{{version}}|$VERSION|g" \
        "$file"
}

# 初始化Git仓库
init_git() {
    cd "$NAME"
    git init
    git add .
    git commit -m "Initial commit from Thor React template"
}

# 安装依赖
install_dependencies() {
    cd "$NAME"
    echo "Installing dependencies..."
    pnpm install
}

# 主函数
main() {
    echo "Creating React project: $NAME"

    check_requirements
    create_project_structure
    init_git
    install_dependencies

    echo "✅ Project created successfully!"
    echo
    echo "To get started:"
    echo "  cd $NAME"
    echo "  pnpm dev"
}

main
#!/usr/bin/env bash
# Core template handling
# 模板类型枚举
declare -A TEMPLATE_TYPES=(
    ["project"]="完整项目模板"
    ["component"]="组件模板"
    ["git"]="Git相关模板"
    ["test"]="测试相关模板"
    ["custom"]="自定义模板"
)

# 初始化模板目录结构
init_template_dirs() {
    for type in "${!TEMPLATE_TYPES[@]}"; do
        mkdir -p "${THOR_TEMPLATE_DIR}/${type}"
    done
}

# 验证模板
validate_template() {
    local template_path="$1"
    local template_type="$2"

    # 检查必需文件
    if [ ! -f "${template_path}/template.json" ]; then
        echo "Error: Missing template.json in ${template_path}" >&2
        return 1
    fi

    # 验证template.json格式
    if ! jq empty "${template_path}/template.json" 2>/dev/null; then
        echo "Error: Invalid template.json format in ${template_path}" >&2
        return 1
    fi

    # 根据模板类型进行特定验证
    case "$template_type" in
        "project")
            if [ ! -f "${template_path}/scaffold.sh" ]; then
                echo "Error: Missing scaffold.sh in project template" >&2
                return 1
            fi
        ;;
        "component")
            if [ ! -f "${template_path}/template.txt" ]; then
                echo "Error: Missing template.txt in component template" >&2
                return 1
            fi
        ;;
    esac

    return 0
}

# 列出可用模板
list_templates() {
    local type="${1:-all}"
    local template_dir="${THOR_TEMPLATE_DIR}"

    if [ "$type" != "all" ] && [ -d "${template_dir}/${type}" ]; then
        template_dir="${template_dir}/${type}"
    fi

    echo "Available templates:"
    echo "------------------"

    for category in "${template_dir}"/*; do
        if [ -d "$category" ]; then
            local category_name=$(basename "$category")
            echo "📁 ${category_name}:"

            for template in "${category}"/*; do
                if [ -d "$template" ] && [ -f "${template}/template.json" ]; then
                    local template_name=$(basename "$template")
                    local description=$(jq -r '.description' "${template}/template.json")
                    echo "  └── 📝 ${template_name}: ${description}"
                fi
            done
            echo
        fi
    done
}

# 安装模板
install_template() {
    local source="$1"
    local type="$2"
    local name="$3"

    local target_dir="${THOR_TEMPLATE_DIR}/${type}/${name}"

    # 如果是URL，先下载
    if [[ "$source" =~ ^https?:// ]]; then
        local temp_dir=$(mktemp -d)
        git clone "$source" "$temp_dir"
        source="$temp_dir"
    fi

    # 验证源目录
    if ! validate_template "$source" "$type"; then
        echo "Error: Invalid template source" >&2
        return 1
    fi

    # 创建目标目录
    mkdir -p "$target_dir"

    # 复制模板文件
    cp -R "${source}/"* "$target_dir/"

    echo "✅ Template installed successfully to: $target_dir"
}

# 删除模板
remove_template() {
    local type="$1"
    local name="$2"

    local template_dir="${THOR_TEMPLATE_DIR}/${type}/${name}"

    if [ ! -d "$template_dir" ]; then
        echo "Error: Template not found: ${type}/${name}" >&2
        return 1
    fi

    rm -rf "$template_dir"
    echo "✅ Template removed: ${type}/${name}"
}

# 使用模板创建内容
apply_template() {
    local type="$1"
    local name="$2"
    local target="$3"
    shift 3
    local vars=("$@")

    local template_dir="${THOR_TEMPLATE_DIR}/${type}/${name}"

    if [ ! -d "$template_dir" ]; then
        echo "Error: Template not found: ${type}/${name}" >&2
        return 1
    fi

    # 根据模板类型处理
    case "$type" in
        "project")
            if [ -f "${template_dir}/scaffold.sh" ]; then
                bash "${template_dir}/scaffold.sh" "$target" "${vars[@]}"
            fi
        ;;
        "component")
            local template_file="${template_dir}/template.txt"
            if [ -f "$template_file" ]; then
                mkdir -p "$(dirname "$target")"
                envsubst < "$template_file" > "$target"
            fi
        ;;
        "git")
            if [ -f "${template_dir}/gitignore" ]; then
                cp "${template_dir}/gitignore" "${target}/.gitignore"
            fi
        ;;
    esac

    # 执行后处理脚本
    if [ -f "${template_dir}/post-process.sh" ]; then
        bash "${template_dir}/post-process.sh" "$target" "${vars[@]}"
    fi
}

# 更新模板
update_template() {
    local type="$1"
    local name="$2"

    local template_dir="${THOR_TEMPLATE_DIR}/${type}/${name}"

    if [ ! -d "$template_dir" ]; then
        echo "Error: Template not found: ${type}/${name}" >&2
        return 1
    fi

    # 如果是git仓库，执行pull
    if [ -d "${template_dir}/.git" ]; then
        (cd "$template_dir" && git pull)
        echo "✅ Template updated: ${type}/${name}"
    else
        echo "⚠️ Template is not a git repository, cannot update"
        return 1
    fi
}

# 创建新的自定义模板
create_template() {
    local type="$1"
    local name="$2"
    local description="$3"

    local template_dir="${THOR_TEMPLATE_DIR}/${type}/${name}"

    if [ -d "$template_dir" ]; then
        echo "Error: Template already exists: ${type}/${name}" >&2
        return 1
    fi

    # 创建模板目录结构
    mkdir -p "$template_dir"

    # 创建template.json
    cat > "${template_dir}/template.json" <<EOF
{
    "name": "${name}",
    "type": "${type}",
    "description": "${description}",
    "version": "1.0.0",
    "author": "$(git config user.name)",
    "license": "MIT"
}
EOF

    # 创建基础文件
    case "$type" in
        "project")
            touch "${template_dir}/scaffold.sh"
            chmod +x "${template_dir}/scaffold.sh"
        ;;
        "component")
            touch "${template_dir}/template.txt"
        ;;
    esac

    echo "✅ Template created: ${type}/${name}"
    echo "📝 Please edit files in: $template_dir"
}
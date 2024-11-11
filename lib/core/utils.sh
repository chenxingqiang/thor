#!/usr/bin/env bash
# General utility functions

# 颜色定义
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# 日志函数
log_info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $*${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ $*${NC}" >&2
}

# 进度显示
show_spinner() {
    local pid=$1
    local message="${2:-Loading...}"
    local spin='-\|/'
    local i=0

    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${BLUE}${spin:$i:1}${NC} $message"
        sleep .1
    done
    printf "\r"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查是否在git仓库中
is_git_repo() {
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# 获取git仓库根目录
get_git_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

# 检查操作系统类型
get_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            echo "linux"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# 检查是否为合法的标识符
is_valid_identifier() {
    [[ "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]
}

# 生成唯一标识符
generate_id() {
    date +%Y%m%d%H%M%S
}

# URL编码
url_encode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] )
                o="${c}"
                ;;
            * )
                printf -v o '%%%02x' "'$c"
                ;;
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

# 检查端口是否可用
is_port_available() {
    local port=$1
    if command_exists nc; then
        ! nc -z localhost $port >/dev/null 2>&1
    elif command_exists lsof; then
        ! lsof -i :$port >/dev/null 2>&1
    else
        true
    fi
}

# 查找可用端口
find_available_port() {
    local start_port=${1:-3000}
    local port=$start_port

    while ! is_port_available $port; do
        port=$((port + 1))
    done

    echo $port
}

# 检查Node.js项目类型
detect_node_project_type() {
    if [ -f "next.config.js" ] || [ -f "next.config.ts" ]; then
        echo "next"
    elif [ -f "nuxt.config.js" ] || [ -f "nuxt.config.ts" ]; then
        echo "nuxt"
    elif [ -f "vite.config.js" ] || [ -f "vite.config.ts" ]; then
        echo "vite"
    elif [ -f "angular.json" ]; then
        echo "angular"
    else
        echo "node"
    fi
}

# 检查包管理器
detect_package_manager() {
    if [ -f "pnpm-lock.yaml" ]; then
        echo "pnpm"
    elif [ -f "yarn.lock" ]; then
        echo "yarn"
    elif [ -f "package-lock.json" ]; then
        echo "npm"
    else
        echo "npm"
    fi
}

# 从package.json获取信息
get_package_info() {
    local key="$1"
    if [ -f "package.json" ]; then
        node -e "console.log(require('./package.json').$key || '')"
    fi
}

# 检查依赖是否已安装
is_dependency_installed() {
    local dep="$1"
    if [ -d "node_modules/$dep" ]; then
        return 0
    fi
    return 1
}

# 递归复制目录
copy_directory() {
    local src="$1"
    local dst="$2"
    local exclude=("${@:3}")

    # 创建目标目录
    mkdir -p "$dst"

    # 复制文件和目录
    for item in "$src"/*; do
        local name=$(basename "$item")
        local skip=false

        # 检查是否在排除列表中
        for excl in "${exclude[@]}"; do
            if [[ "$name" == "$excl" ]]; then
                skip=true
                break
            fi
        done

        if [ "$skip" = true ]; then
            continue
        fi

        if [ -d "$item" ]; then
            copy_directory "$item" "$dst/$name" "${exclude[@]}"
        else
            cp "$item" "$dst/$name"
        fi
    done
}

# 替换文件中的占位符
replace_placeholders() {
    local file="$1"
    shift
    local vars=("$@")

    if [ ! -f "$file" ]; then
        return 1
    fi

    local temp_file=$(mktemp)
    cp "$file" "$temp_file"

    for var in "${vars[@]}"; do
        local key="${var%%=*}"
        local value="${var#*=}"
        sed -i "s|{{${key}}}|${value}|g" "$temp_file"
    done

    mv "$temp_file" "$file"
}

# 获取用户输入（带默认值）
read_input() {
    local prompt="$1"
    local default="$2"
    local result

    if [ -n "$default" ]; then
        prompt="$prompt [$default]"
    fi

    read -p "$prompt: " result
    echo "${result:-$default}"
}

# 获取密码输入
read_password() {
    local prompt="$1"
    local password

    read -s -p "$prompt: " password
    echo
    echo "$password"
}

# 检查文件内容
assert_file_contains() {
    local file="$1"
    local pattern="$2"

    if grep -q "$pattern" "$file"; then
        return 0
    else
        echo " ❌ (pattern not found in file: $pattern)"
        return 1
    fi
}

# 进度条显示
show_progress() {
    local current="$1"
    local total="$2"
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((percentage * width / 100))
    local empty=$((width - filled))

    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%" "$percentage"
}

# 检查依赖版本
check_version() {
    local command="$1"
    local required="$2"

    if ! command -v "$command" >/dev/null 2>&1; then
        return 1
    fi

    local version
    case "$command" in
        node)
            version=$(node --version | cut -d'v' -f2)
            ;;
        pnpm)
            version=$(pnpm --version)
            ;;
        *)
            version=$("$command" --version)
            ;;
    esac

    printf '%s\n%s\n' "$version" "$required" | sort -V | head -n1 | grep -q "^$required"
}

# 解析YAML配置
parse_yaml() {
    local yaml_file="$1"
    local prefix="$2"

    python3 -c "
import yaml
import sys

with open('$yaml_file') as f:
    data = yaml.safe_load(f)

def flatten(d, parent_key=''):
    items = []
    for k, v in d.items():
        new_key = f'{parent_key}{k}' if parent_key else k
        if isinstance(v, dict):
            items.extend(flatten(v, f'{new_key}.').items())
        else:
            items.append((new_key, v))
    return dict(items)

flat = flatten(data)
for k, v in flat.items():
    print(f'{prefix}{k}={v}')
"
}

# 安全的命令执行
safe_execute() {
    local command="$1"
    shift

    if [ "$THOR_DEBUG" = "true" ]; then
        echo "Executing: $command $*"
    fi

    if ! "$command" "$@"; then
        echo "Error executing command: $command $*"
        return 1
    fi
}

# 缓存管理
cache_get() {
    local key="$1"
    local cache_file="${THOR_CACHE_DIR}/${key}"

    if [ -f "$cache_file" ]; then
        cat "$cache_file"
        return 0
    fi
    return 1
}

cache_set() {
    local key="$1"
    local value="$2"
    local cache_file="${THOR_CACHE_DIR}/${key}"

    mkdir -p "$(dirname "$cache_file")"
    echo "$value" > "$cache_file"
}

cache_clear() {
    local key="$1"

    if [ -n "$key" ]; then
        rm -f "${THOR_CACHE_DIR}/${key}"
    else
        rm -rf "${THOR_CACHE_DIR:?}/"*
    fi
}
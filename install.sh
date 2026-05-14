#!/usr/bin/env bash
# UEE 安装脚本
# 在你当前项目中激活 Universal Expert Engine
#
# 用法：
#   ~/.uee/install.sh                       # 全局模式（默认），target=当前目录
#   ~/.uee/install.sh --local               # 局部模式，把 UEE 复制到目标项目
#   ~/.uee/install.sh --uee-dir=/path/uee   # 指定 UEE 仓库位置
#   ~/.uee/install.sh --target=/path        # 指定目标项目
#   ~/.uee/install.sh --help

set -e

# ===== 默认值 =====
UEE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"
MODE="global"   # global | local
PLATFORMS=()    # 留空 = 自动检测
VERBOSE=0

# ===== UEE 标记（用于卸载时识别 UEE 管理的文件）=====
UEE_MARK="<!-- UEE-MANAGED -->"

# ===== 解析参数 =====
print_help() {
  cat << 'EOF'
UEE — 在你的项目中激活全能专家引擎

用法：
  install.sh [OPTIONS]

OPTIONS:
  --global              全局模式：配置引用 UEE 仓库（默认）
  --local               局部模式：把 UEE 复制到目标项目内的 .uee/ 子目录
  --uee-dir=PATH        指定 UEE 仓库位置（默认：脚本所在目录）
  --target=PATH         指定要激活的目标项目（默认：当前目录）
  --platform=NAME       仅配置某个平台，可重复使用：
                          --platform=kiro --platform=cursor
                        支持：kiro / cursor / windsurf / claude-code
  -v, --verbose         显示详细日志
  -h, --help            显示此帮助

示例：
  # 一次性下载 UEE 到全局位置（用户做一次）
  git clone https://github.com/Futurejason/bootstrap-pipeline.git ~/.uee

  # 在当前项目激活（自动检测平台，全局模式）
  ~/.uee/install.sh

  # 在指定项目激活，局部模式（项目自包含）
  ~/.uee/install.sh --target=~/projects/my-app --local

  # 仅配置 Cursor
  ~/.uee/install.sh --platform=cursor

  # 卸载
  ~/.uee/uninstall.sh
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global) MODE="global"; shift ;;
    --local) MODE="local"; shift ;;
    --uee-dir=*) UEE_DIR="${1#*=}"; shift ;;
    --target=*) TARGET_DIR="${1#*=}"; shift ;;
    --platform=*) PLATFORMS+=("${1#*=}"); shift ;;
    -v|--verbose) VERBOSE=1; shift ;;
    -h|--help) print_help; exit 0 ;;
    *) echo "Unknown option: $1"; print_help; exit 1 ;;
  esac
done

# ===== 路径规整 =====
UEE_DIR="$(cd "$UEE_DIR" 2>/dev/null && pwd)" || { echo "❌ UEE 仓库不存在：$UEE_DIR"; exit 1; }
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || { echo "❌ 目标目录不存在：$TARGET_DIR"; exit 1; }

# ===== 校验 UEE 仓库完整性 =====
if [ ! -f "$UEE_DIR/entry.md" ] || [ ! -d "$UEE_DIR/skills" ]; then
  echo "❌ $UEE_DIR 不是有效的 UEE 仓库（缺 entry.md 或 skills/）"
  exit 1
fi

echo "=========================================="
echo "  UEE 激活"
echo "=========================================="
echo "  UEE 仓库：$UEE_DIR"
echo "  目标项目：$TARGET_DIR"
echo "  模式：$MODE"
echo ""

# ===== 局部模式：复制 UEE 到目标项目 =====
if [ "$MODE" = "local" ]; then
  if [ -d "$TARGET_DIR/.uee" ]; then
    echo "⚠️  $TARGET_DIR/.uee 已存在，覆盖？[y/N]"
    read -r confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "已取消"; exit 0; }
    rm -rf "$TARGET_DIR/.uee"
  fi
  echo "→ 复制 UEE 到 $TARGET_DIR/.uee ..."
  mkdir -p "$TARGET_DIR/.uee"
  # 只复制运行时需要的内容（不复制 .git / .test-records / 自身）
  for item in entry.md ETHOS.md ARCHITECTURE.md README.md VERSION skills orchestrator experts quality-gates adapters templates examples; do
    if [ -e "$UEE_DIR/$item" ]; then
      cp -r "$UEE_DIR/$item" "$TARGET_DIR/.uee/"
    fi
  done
  EFFECTIVE_UEE_DIR="$TARGET_DIR/.uee"
  echo "  ✓ UEE 已复制到 $EFFECTIVE_UEE_DIR"
else
  EFFECTIVE_UEE_DIR="$UEE_DIR"
fi

# ===== 平台检测 =====
detect_platforms() {
  local detected=()
  [ -d "$TARGET_DIR/.kiro" ] && detected+=("kiro")
  command -v cursor >/dev/null 2>&1 && detected+=("cursor")
  command -v windsurf >/dev/null 2>&1 && detected+=("windsurf")
  command -v claude >/dev/null 2>&1 && detected+=("claude-code")
  echo "${detected[@]}"
}

if [ ${#PLATFORMS[@]} -eq 0 ]; then
  PLATFORMS=($(detect_platforms))
  if [ ${#PLATFORMS[@]} -eq 0 ]; then
    echo "未自动检测到平台。请选择要配置的平台："
    echo "  1) Kiro"
    echo "  2) Cursor"
    echo "  3) Windsurf"
    echo "  4) Claude Code"
    echo "  5) 全部"
    echo "  q) 退出"
    read -rp "选择: " choice
    case "$choice" in
      1) PLATFORMS=("kiro") ;;
      2) PLATFORMS=("cursor") ;;
      3) PLATFORMS=("windsurf") ;;
      4) PLATFORMS=("claude-code") ;;
      5) PLATFORMS=("kiro" "cursor" "windsurf" "claude-code") ;;
      *) exit 0 ;;
    esac
  else
    echo "检测到平台：${PLATFORMS[*]}"
  fi
fi

# ===== 计算相对路径（仅 Kiro 用）=====
relpath() {
  local from="$1"
  local to="$2"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "import os.path; print(os.path.relpath('$to', '$from'))"
  elif command -v perl >/dev/null 2>&1; then
    perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1])' "$to" "$from"
  else
    # 简单 fallback：用绝对路径
    echo "$to"
  fi
}

# ===== 各平台配置 =====

setup_kiro() {
  echo "→ 配置 Kiro..."
  mkdir -p "$TARGET_DIR/.kiro/steering"
  local rel
  rel=$(relpath "$TARGET_DIR/.kiro/steering" "$EFFECTIVE_UEE_DIR")
  cat > "$TARGET_DIR/.kiro/steering/uee.md" << EOF
---
inclusion: auto
---

$UEE_MARK
# Universal Expert Engine

#[[file:$rel/entry.md]]
#[[file:$rel/ETHOS.md]]
#[[file:$rel/orchestrator/ORCHESTRATOR.md]]
#[[file:$rel/orchestrator/routing-rules.md]]
#[[file:$rel/quality-gates/four-dimensions.md]]
#[[file:$rel/quality-gates/evidence-chain.md]]
#[[file:$rel/skills/classify/SKILL.md]]
#[[file:$rel/skills/clarify/SKILL.md]]
#[[file:$rel/skills/resource/SKILL.md]]
#[[file:$rel/skills/plan/SKILL.md]]
#[[file:$rel/skills/design/SKILL.md]]
#[[file:$rel/skills/execute/SKILL.md]]
#[[file:$rel/skills/review/SKILL.md]]
#[[file:$rel/skills/deliver/SKILL.md]]
#[[file:$rel/skills/refine/SKILL.md]]
EOF
  echo "  ✓ $TARGET_DIR/.kiro/steering/uee.md"
  echo "  → 重启 Kiro 让规则生效"
}

setup_cursor() {
  echo "→ 配置 Cursor..."
  local target="$TARGET_DIR/.cursorrules"
  if [ -f "$target" ] && ! grep -q "$UEE_MARK" "$target"; then
    echo "  ⚠️  $target 已存在且非 UEE 管理，备份为 $target.bak"
    cp "$target" "$target.bak"
  fi
  {
    echo "$UEE_MARK"
    cat "$EFFECTIVE_UEE_DIR/entry.md"
  } > "$target"
  echo "  ✓ $target"
  echo "  → 重启 Cursor 让规则生效"
}

setup_windsurf() {
  echo "→ 配置 Windsurf..."
  local target="$TARGET_DIR/.windsurfrules"
  if [ -f "$target" ] && ! grep -q "$UEE_MARK" "$target"; then
    echo "  ⚠️  $target 已存在且非 UEE 管理，备份为 $target.bak"
    cp "$target" "$target.bak"
  fi
  {
    echo "$UEE_MARK"
    cat "$EFFECTIVE_UEE_DIR/entry.md"
  } > "$target"
  echo "  ✓ $target"
  echo "  → 重启 Windsurf 让规则生效"
}

setup_claude_code() {
  echo "→ 配置 Claude Code..."
  local target="$TARGET_DIR/CLAUDE.md"
  if [ -f "$target" ] && ! grep -q "$UEE_MARK" "$target"; then
    echo "  ⚠️  $target 已存在且非 UEE 管理，备份为 $target.bak"
    cp "$target" "$target.bak"
  fi
  {
    echo "$UEE_MARK"
    cat "$EFFECTIVE_UEE_DIR/entry.md"
  } > "$target"
  echo "  ✓ $target"
  echo "  → 在该目录下运行 'claude' 即可使用"
}

# ===== 执行配置 =====
for p in "${PLATFORMS[@]}"; do
  case "$p" in
    kiro) setup_kiro ;;
    cursor) setup_cursor ;;
    windsurf) setup_windsurf ;;
    claude-code) setup_claude_code ;;
    *) echo "  ⚠️  未知平台：$p（跳过）" ;;
  esac
done

echo ""
echo "=========================================="
echo "  ✅ 安装完成"
echo "=========================================="
echo ""
echo "对于 ChatGPT / Claude Projects 等 Web 平台："
echo "  请将 $EFFECTIVE_UEE_DIR/entry.md 内容粘贴到 Instructions"
echo ""
echo "卸载：~/.uee/uninstall.sh --target=$TARGET_DIR"

#!/usr/bin/env bash
# UEE 安装脚本
# 在你当前项目中激活 Universal Expert Engine
#
# 用法：
#   ~/.uee/install.sh                       # 全局模式（默认），交互式选平台
#   ~/.uee/install.sh --local               # 局部模式
#   ~/.uee/install.sh --uee-dir=/path/uee   # 指定 UEE 仓库位置
#   ~/.uee/install.sh --target=/path        # 指定目标项目
#   ~/.uee/install.sh --platform=kiro       # 指定平台（跳过交互）
#   ~/.uee/install.sh --yes                 # 自动选检测到的全部
#   ~/.uee/install.sh --help

set -e

# ===== 默认值 =====
UEE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"
MODE="global"   # global | local
SELECTED_PLATFORMS=()
YES=0
VERBOSE=0

# ===== UEE 标记（用于卸载时识别 UEE 管理的文件）=====
UEE_MARK="<!-- UEE-MANAGED -->"

# ===== 所有支持的平台 =====
ALL_PLATFORMS=("kiro" "cursor" "windsurf" "claude-code")

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
  --platform=NAME       指定平台（跳过交互），可重复使用：
                          --platform=kiro --platform=cursor
                        支持值：kiro / cursor / windsurf / claude-code
  -y, --yes             自动确认（跳过交互菜单，安装检测到的全部平台）
  -v, --verbose         显示详细日志
  -h, --help            显示此帮助

示例：
  # 一次性下载 UEE 到全局位置（用户做一次）
  git clone https://github.com/Futurejason/bootstrap-pipeline.git ~/.uee

  # 在当前项目激活（交互式选平台）
  ~/.uee/install.sh

  # 自动安装检测到的全部平台（CI 友好）
  ~/.uee/install.sh --yes

  # 只安装 Kiro 和 Cursor
  ~/.uee/install.sh --platform=kiro --platform=cursor

  # 局部模式
  ~/.uee/install.sh --local

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
    --platform=*) SELECTED_PLATFORMS+=("${1#*=}"); shift ;;
    -y|--yes) YES=1; shift ;;
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

# ===== 平台检测 =====
detect_platform() {
  local p="$1"
  case "$p" in
    kiro) [ -d "$TARGET_DIR/.kiro" ] || pgrep -f "Kiro" >/dev/null 2>&1 ;;
    cursor) command -v cursor >/dev/null 2>&1 ;;
    windsurf) command -v windsurf >/dev/null 2>&1 ;;
    claude-code) command -v claude >/dev/null 2>&1 ;;
    *) return 1 ;;
  esac
}

is_already_installed() {
  local p="$1"
  case "$p" in
    kiro) [ -f "$TARGET_DIR/.kiro/steering/uee.md" ] && grep -q "$UEE_MARK" "$TARGET_DIR/.kiro/steering/uee.md" 2>/dev/null ;;
    cursor) [ -f "$TARGET_DIR/.cursorrules" ] && grep -q "$UEE_MARK" "$TARGET_DIR/.cursorrules" 2>/dev/null ;;
    windsurf) [ -f "$TARGET_DIR/.windsurfrules" ] && grep -q "$UEE_MARK" "$TARGET_DIR/.windsurfrules" 2>/dev/null ;;
    claude-code) [ -f "$TARGET_DIR/CLAUDE.md" ] && grep -q "$UEE_MARK" "$TARGET_DIR/CLAUDE.md" 2>/dev/null ;;
    *) return 1 ;;
  esac
}

# ===== 多选交互菜单 =====
interactive_select() {
  echo "检测到当前可用的平台："
  echo ""

  local i=1
  local detected=()
  local statuses=()

  for p in "${ALL_PLATFORMS[@]}"; do
    local status=""
    if detect_platform "$p"; then
      detected+=("$p")
      if is_already_installed "$p"; then
        status="✓ 已检测到 | 已安装"
      else
        status="✓ 已检测到 | 未安装"
      fi
    else
      status="  未检测到"
    fi
    statuses+=("$status")
    printf "  [%d] %-12s %s\n" "$i" "$p" "$status"
    i=$((i + 1))
  done

  echo ""
  echo "选择要安装的平台："
  echo "  - 输入编号（多选用逗号分隔）：例 1,2"
  echo "  - 输入平台名：例 kiro,cursor"
  echo "  - 输入 a / all：全部"
  echo "  - 输入 d / detected：检测到的全部"
  echo "  - 输入 q / 留空：退出"
  echo ""
  read -rp "你的选择: " choice

  if [ -z "$choice" ] || [[ "$choice" =~ ^(q|Q)$ ]]; then
    echo "已取消"
    exit 0
  fi

  if [[ "$choice" =~ ^(a|A|all|ALL)$ ]]; then
    SELECTED_PLATFORMS=("${ALL_PLATFORMS[@]}")
    return
  fi

  if [[ "$choice" =~ ^(d|D|detected|DETECTED)$ ]]; then
    SELECTED_PLATFORMS=("${detected[@]}")
    return
  fi

  # 解析编号或名称
  IFS=',' read -ra parts <<< "$choice"
  for part in "${parts[@]}"; do
    part="$(echo "$part" | xargs)"  # trim
    if [[ "$part" =~ ^[0-9]+$ ]]; then
      local idx=$((part - 1))
      if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#ALL_PLATFORMS[@]}" ]; then
        SELECTED_PLATFORMS+=("${ALL_PLATFORMS[$idx]}")
      else
        echo "  ⚠️  忽略无效编号：$part"
      fi
    else
      # 检查是否是合法平台名
      local valid=0
      for p in "${ALL_PLATFORMS[@]}"; do
        [ "$p" = "$part" ] && valid=1 && break
      done
      if [ "$valid" -eq 1 ]; then
        SELECTED_PLATFORMS+=("$part")
      else
        echo "  ⚠️  忽略无效平台名：$part"
      fi
    fi
  done
}

# ===== 决定要安装的平台 =====
if [ ${#SELECTED_PLATFORMS[@]} -eq 0 ]; then
  if [ "$YES" -eq 1 ]; then
    # --yes：自动选检测到的全部
    for p in "${ALL_PLATFORMS[@]}"; do
      detect_platform "$p" && SELECTED_PLATFORMS+=("$p")
    done
    if [ ${#SELECTED_PLATFORMS[@]} -eq 0 ]; then
      echo "❌ --yes 模式下未检测到任何平台。请用 --platform=NAME 显式指定。"
      exit 1
    fi
    echo "自动选择（--yes）：${SELECTED_PLATFORMS[*]}"
  else
    interactive_select
  fi
fi

if [ ${#SELECTED_PLATFORMS[@]} -eq 0 ]; then
  echo "未选择任何平台，退出。"
  exit 0
fi

# ===== 二次确认 =====
echo ""
echo "将安装以下平台："
for p in "${SELECTED_PLATFORMS[@]}"; do
  if is_already_installed "$p"; then
    echo "  - $p（覆盖已安装）"
  else
    echo "  - $p"
  fi
done
echo ""

if [ "$YES" -ne 1 ] && [ ${#SELECTED_PLATFORMS[@]} -gt 0 ] && [ -z "$ALREADY_CONFIRMED" ]; then
  read -rp "确认？[Y/n] " confirm
  if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "已取消"
    exit 0
  fi
fi

# ===== 局部模式：复制 UEE 到目标项目 =====
if [ "$MODE" = "local" ]; then
  if [ -d "$TARGET_DIR/.uee" ]; then
    if [ "$YES" -ne 1 ]; then
      echo "⚠️  $TARGET_DIR/.uee 已存在，覆盖？[y/N]"
      read -r confirm
      [[ "$confirm" =~ ^[Yy]$ ]] || { echo "已取消"; exit 0; }
    fi
    rm -rf "$TARGET_DIR/.uee"
  fi
  echo "→ 复制 UEE 到 $TARGET_DIR/.uee ..."
  mkdir -p "$TARGET_DIR/.uee"
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

# ===== 计算相对路径（仅 Kiro 用）=====
relpath() {
  local from="$1"
  local to="$2"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "import os.path; print(os.path.relpath('$to', '$from'))"
  elif command -v perl >/dev/null 2>&1; then
    perl -e 'use File::Spec; print File::Spec->abs2rel($ARGV[0], $ARGV[1])' "$to" "$from"
  else
    echo "$to"
  fi
}

# ===== 各平台配置 =====

setup_kiro() {
  echo "→ 配置 Kiro..."
  mkdir -p "$TARGET_DIR/.kiro/steering"

  # 策略：把 UEE 关键文件复制到 .kiro/steering/uee-files/
  # 优点：路径短而清晰、不依赖 home 路径、项目可移植、Kiro 100% 兼容
  # 即使用户在不同机器或路径运行项目都能正常加载
  local kiro_uee_dir="$TARGET_DIR/.kiro/steering/uee-files"
  rm -rf "$kiro_uee_dir"
  mkdir -p "$kiro_uee_dir"

  # 复制 UEE 全部核心文件供 AI 按需读取（不通过 steering 强制加载）
  cp "$EFFECTIVE_UEE_DIR/entry.md" "$kiro_uee_dir/"
  cp "$EFFECTIVE_UEE_DIR/ETHOS.md" "$kiro_uee_dir/"
  cp -r "$EFFECTIVE_UEE_DIR/orchestrator" "$kiro_uee_dir/"
  cp -r "$EFFECTIVE_UEE_DIR/quality-gates" "$kiro_uee_dir/"
  cp -r "$EFFECTIVE_UEE_DIR/skills" "$kiro_uee_dir/"

  # uee.md 只主动加载 entry.md（避免 context 爆炸导致网络超时/中断）
  # entry.md 已含完整 9 阶段流程概要；详细规范用户/AI 需要时自行 read uee-files/
  cat > "$TARGET_DIR/.kiro/steering/uee.md" << EOF
---
inclusion: auto
---

$UEE_MARK
# Universal Expert Engine

引擎入口（已包含 9 阶段流程的完整概要）：

#[[file:uee-files/entry.md]]

## 详细规范（按需读取，不自动加载）

如需查阅细节，请读取以下文件（不要全部加载，按需查阅）：

- 行为准则：\`.kiro/steering/uee-files/ETHOS.md\`
- 流程编排：\`.kiro/steering/uee-files/orchestrator/ORCHESTRATOR.md\`
- 路由规则：\`.kiro/steering/uee-files/orchestrator/routing-rules.md\`
- 三档流程：\`.kiro/steering/uee-files/orchestrator/flows/L{1,2,3}-*.md\`
- 质量四维：\`.kiro/steering/uee-files/quality-gates/four-dimensions.md\`
- 证据链：\`.kiro/steering/uee-files/quality-gates/evidence-chain.md\`
- 可信度标注：\`.kiro/steering/uee-files/quality-gates/confidence-marker.md\`
- 对抗性自检：\`.kiro/steering/uee-files/quality-gates/adversarial-check.md\`
- 失败降级：\`.kiro/steering/uee-files/quality-gates/fallback-strategy.md\`
- 9 个 Skill：\`.kiro/steering/uee-files/skills/<name>/SKILL.md\`
EOF
  echo "  ✓ $TARGET_DIR/.kiro/steering/uee.md（仅引用 entry.md 避免 context 过载）"
  echo "  ✓ UEE 核心文件已复制到 $TARGET_DIR/.kiro/steering/uee-files/（AI 按需读取）"
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
echo ""
for p in "${SELECTED_PLATFORMS[@]}"; do
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
echo "已安装的平台：${SELECTED_PLATFORMS[*]}"
echo ""
echo "对于 ChatGPT / Claude Projects 等 Web 平台："
echo "  请将 $EFFECTIVE_UEE_DIR/entry.md 内容粘贴到 Instructions"
echo ""
echo "卸载："
echo "  $UEE_DIR/uninstall.sh --target=$TARGET_DIR"
echo ""
echo "再次安装其他平台："
echo "  $UEE_DIR/install.sh --target=$TARGET_DIR --platform=NAME"

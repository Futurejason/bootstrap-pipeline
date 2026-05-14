#!/usr/bin/env bash
# UEE 一键安装脚本
# 自动检测目标平台并配置

set -e

UEE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"

echo "=========================================="
echo "  Universal Expert Engine — Setup"
echo "=========================================="
echo ""
echo "UEE 仓库位置: $UEE_DIR"
echo "目标项目位置: $TARGET_DIR"
echo ""

# 平台检测
detect_platform() {
  local platforms=()

  # Kiro: 检查 .kiro 目录或 Kiro 进程
  if [ -d "$TARGET_DIR/.kiro" ] || pgrep -f "Kiro" >/dev/null 2>&1; then
    platforms+=("kiro")
  fi

  # Cursor: 检查 .cursor 目录或 cursor 命令
  if [ -d "$TARGET_DIR/.cursor" ] || command -v cursor >/dev/null 2>&1; then
    platforms+=("cursor")
  fi

  # Windsurf: 检查 .windsurf 目录
  if [ -d "$TARGET_DIR/.windsurf" ] || command -v windsurf >/dev/null 2>&1; then
    platforms+=("windsurf")
  fi

  # Claude Code: 检查 claude 命令
  if command -v claude >/dev/null 2>&1; then
    platforms+=("claude-code")
  fi

  echo "${platforms[@]}"
}

# 配置 Kiro
setup_kiro() {
  echo "→ 配置 Kiro..."
  mkdir -p "$TARGET_DIR/.kiro/steering"

  # 计算 UEE 相对路径
  local rel_path
  rel_path=$(python3 -c "import os.path; print(os.path.relpath('$UEE_DIR', '$TARGET_DIR/.kiro/steering'))")

  cat > "$TARGET_DIR/.kiro/steering/uee.md" << EOF
---
inclusion: auto
---

# Universal Expert Engine

#[[file:$rel_path/entry.md]]
#[[file:$rel_path/ETHOS.md]]
#[[file:$rel_path/orchestrator/ORCHESTRATOR.md]]
#[[file:$rel_path/orchestrator/routing-rules.md]]
#[[file:$rel_path/quality-gates/four-dimensions.md]]
#[[file:$rel_path/quality-gates/evidence-chain.md]]
#[[file:$rel_path/skills/classify/SKILL.md]]
#[[file:$rel_path/skills/clarify/SKILL.md]]
#[[file:$rel_path/skills/resource/SKILL.md]]
#[[file:$rel_path/skills/plan/SKILL.md]]
#[[file:$rel_path/skills/design/SKILL.md]]
#[[file:$rel_path/skills/execute/SKILL.md]]
#[[file:$rel_path/skills/review/SKILL.md]]
#[[file:$rel_path/skills/deliver/SKILL.md]]
#[[file:$rel_path/skills/refine/SKILL.md]]
EOF
  echo "  ✓ 已生成 $TARGET_DIR/.kiro/steering/uee.md"
  echo "  → 重启 Kiro 让规则生效"
}

# 配置 Cursor
setup_cursor() {
  echo "→ 配置 Cursor..."
  cp "$UEE_DIR/entry.md" "$TARGET_DIR/.cursorrules"
  echo "  ✓ 已生成 $TARGET_DIR/.cursorrules"
  echo "  → 重启 Cursor 让规则生效"
}

# 配置 Windsurf
setup_windsurf() {
  echo "→ 配置 Windsurf..."
  cp "$UEE_DIR/entry.md" "$TARGET_DIR/.windsurfrules"
  echo "  ✓ 已生成 $TARGET_DIR/.windsurfrules"
  echo "  → 重启 Windsurf 让规则生效"
}

# 配置 Claude Code
setup_claude_code() {
  echo "→ 配置 Claude Code..."
  cp "$UEE_DIR/entry.md" "$TARGET_DIR/CLAUDE.md"
  echo "  ✓ 已生成 $TARGET_DIR/CLAUDE.md"
  echo "  → 在 $TARGET_DIR 目录下运行 'claude' 即可"
}

# 主流程
main() {
  local detected=($(detect_platform))

  if [ ${#detected[@]} -eq 0 ]; then
    echo "未检测到支持的平台。"
    echo ""
    echo "请手动选择要配置的平台："
    echo "  1) Kiro"
    echo "  2) Cursor"
    echo "  3) Windsurf"
    echo "  4) Claude Code"
    echo "  5) 全部配置"
    echo "  q) 退出"
    read -rp "选择 [1-5/q]: " choice

    case "$choice" in
      1) setup_kiro ;;
      2) setup_cursor ;;
      3) setup_windsurf ;;
      4) setup_claude_code ;;
      5) setup_kiro; setup_cursor; setup_windsurf; setup_claude_code ;;
      *) exit 0 ;;
    esac
  else
    echo "检测到以下平台：${detected[*]}"
    echo ""
    read -rp "全部自动配置？[Y/n] " confirm

    if [[ "$confirm" =~ ^[Nn]$ ]]; then
      echo "已取消。"
      exit 0
    fi

    for p in "${detected[@]}"; do
      case "$p" in
        kiro) setup_kiro ;;
        cursor) setup_cursor ;;
        windsurf) setup_windsurf ;;
        claude-code) setup_claude_code ;;
      esac
    done
  fi

  echo ""
  echo "=========================================="
  echo "  ✅ 安装完成"
  echo "=========================================="
  echo ""
  echo "ChatGPT / Claude Projects 需要手动操作："
  echo "  → ChatGPT: 创建 GPT，把 entry.md 内容粘贴到 Instructions"
  echo "  → Claude:  创建 Project，把 entry.md 内容粘贴到 Project Instructions"
  echo ""
  echo "验证安装：在你的 AI 工具里提任意问题"
  echo "  正常情况下 AI 会先输出 [classify] 而不是直接回答"
  echo ""
  echo "更多详情：见 INSTALL.md"
}

main "$@"

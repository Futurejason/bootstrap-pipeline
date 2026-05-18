#!/usr/bin/env bash
# UEE 卸载脚本
# 清理在目标项目中由 UEE 注入的所有文件
#
# 用法：
#   ~/.uee/uninstall.sh                       # target=当前目录
#   ~/.uee/uninstall.sh --target=/path        # 指定目标项目
#   ~/.uee/uninstall.sh --force               # 不询问直接清理

set -e

TARGET_DIR="$(pwd)"
FORCE=0
UEE_MARK="<!-- UEE-MANAGED -->"

print_help() {
  cat << 'EOF'
UEE 卸载 — 清理目标项目中由 UEE 注入的文件

用法：
  uninstall.sh [OPTIONS]

OPTIONS:
  --target=PATH    指定要清理的目标项目（默认：当前目录）
  --force          不询问，直接清理
  -h, --help       显示帮助

清理范围（仅清理含 UEE-MANAGED 标记的文件）：
  - <target>/.cursorrules
  - <target>/.windsurfrules
  - <target>/CLAUDE.md
  - <target>/.kiro/steering/uee.md
  - <target>/.uee/                  # 局部模式产生的目录

不会动你自己写的非 UEE 配置文件。
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target=*) TARGET_DIR="${1#*=}"; shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) print_help; exit 0 ;;
    *) echo "Unknown option: $1"; print_help; exit 1 ;;
  esac
done

TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || { echo "❌ 目标目录不存在：$TARGET_DIR"; exit 1; }

echo "=========================================="
echo "  UEE 卸载"
echo "=========================================="
echo "  目标项目：$TARGET_DIR"
echo ""

# 收集要删除的项
TO_DELETE=()

check_and_add() {
  local path="$1"
  local kind="$2"  # file | dir
  if [ "$kind" = "file" ] && [ -f "$path" ]; then
    if grep -q "$UEE_MARK" "$path" 2>/dev/null; then
      TO_DELETE+=("$path")
    fi
  elif [ "$kind" = "dir" ] && [ -d "$path" ]; then
    TO_DELETE+=("$path")
  fi
}

check_and_add "$TARGET_DIR/.cursorrules" file
check_and_add "$TARGET_DIR/.windsurfrules" file
check_and_add "$TARGET_DIR/CLAUDE.md" file
check_and_add "$TARGET_DIR/.kiro/steering/uee.md" file
check_and_add "$TARGET_DIR/.kiro/steering/uee-files" dir
check_and_add "$TARGET_DIR/.uee-data" dir
check_and_add "$TARGET_DIR/.uee" dir

if [ ${#TO_DELETE[@]} -eq 0 ]; then
  echo "未找到 UEE 管理的文件，无需清理。"
  exit 0
fi

echo "将删除以下项："
for item in "${TO_DELETE[@]}"; do
  echo "  - $item"
done
echo ""

if [ "$FORCE" -ne 1 ]; then
  read -rp "确认删除？[y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || { echo "已取消"; exit 0; }
fi

for item in "${TO_DELETE[@]}"; do
  rm -rf "$item"
  echo "  ✓ 已删除 $item"
done

# 检查 .cursorrules / .windsurfrules / CLAUDE.md 是否有 .bak 备份，提示恢复
for backup in "$TARGET_DIR/.cursorrules.bak" "$TARGET_DIR/.windsurfrules.bak" "$TARGET_DIR/CLAUDE.md.bak"; do
  if [ -f "$backup" ]; then
    original="${backup%.bak}"
    echo ""
    echo "💡 检测到备份 $backup"
    if [ "$FORCE" -ne 1 ]; then
      read -rp "  恢复到 $original？[y/N] " confirm
      if [[ "$confirm" =~ ^[Yy]$ ]]; then
        mv "$backup" "$original"
        echo "  ✓ 已恢复"
      fi
    fi
  fi
done

# 如果 .kiro/steering 目录空了，删掉
if [ -d "$TARGET_DIR/.kiro/steering" ] && [ -z "$(ls -A "$TARGET_DIR/.kiro/steering")" ]; then
  rmdir "$TARGET_DIR/.kiro/steering"
fi
if [ -d "$TARGET_DIR/.kiro" ] && [ -z "$(ls -A "$TARGET_DIR/.kiro")" ]; then
  rmdir "$TARGET_DIR/.kiro"
fi

echo ""
echo "✅ 卸载完成"

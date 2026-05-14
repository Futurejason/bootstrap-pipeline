# Windsurf 平台适配

## 平台特性

- 通过 `.windsurfrules` 加载规则
- 类似 Cursor 体验
- 终端可用

## 在你的项目里激活 UEE

### 推荐方式：用 install.sh

```bash
cd ~/projects/my-app
~/.uee/install.sh
# 或仅 Windsurf
~/.uee/install.sh --platform=windsurf
```

脚本会在你的项目里生成 `.windsurfrules`（已存在的会备份为 `.bak`）。

### 手动方式

```bash
cd ~/projects/my-app
cp ~/.uee/entry.md .windsurfrules
```

## 验证

1. 重启 Windsurf
2. 提任意问题
3. AI 应走 UEE 流程

## 升级 UEE

```bash
cd ~/.uee
git pull origin main

cd ~/projects/my-app
~/.uee/install.sh --platform=windsurf
```

## 卸载

```bash
cd ~/projects/my-app
~/.uee/uninstall.sh --platform=windsurf
```

## 文件组织规则

按 ETHOS 规则，新任务产出放独立目录。

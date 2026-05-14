# Cursor 平台适配

## 平台特性

- 通过 `.cursorrules` 文件加载规则
- 支持 Settings → Rules for AI 配置
- 终端 + 文件读写可用

## 在你的项目里激活 UEE

### 推荐方式：用 install.sh

```bash
# 进入你自己的项目
cd ~/projects/my-app

# 激活（自动检测平台，会自动配置 Cursor）
~/.uee/install.sh

# 或仅配置 Cursor
~/.uee/install.sh --platform=cursor
```

脚本会：
1. 在你的项目里生成 `.cursorrules`（含 `<!-- UEE-MANAGED -->` 标记）
2. 如果你已有 `.cursorrules`，先备份为 `.cursorrules.bak`

### 手动方式

```bash
cd ~/projects/my-app

# 全局引用（依赖 ~/.uee 仓库）
cp ~/.uee/entry.md .cursorrules

# 或局部嵌入（项目自包含）
cp -r ~/.uee/{entry.md,ETHOS.md,skills,orchestrator,experts,quality-gates,templates} .uee/
cp .uee/entry.md .cursorrules
```

## 验证

1. 重启 Cursor
2. 用 Cmd+L 打开 chat，提问"你好"
3. AI 应进入 UEE 流程（先 classify）

如果没生效：
- 检查 `.cursorrules` 在项目根目录
- 文件内容用 `head -3 .cursorrules` 应能看到 `<!-- UEE-MANAGED -->`
- 重启 Cursor

## Cursor 特有能力利用

### 1. Cmd+K vs Cmd+L
- Cmd+L 适合走 UEE 整体流程（深度对话）
- Cmd+K 适合调用单 skill（"用 review 检查这块代码"）

### 2. @file / @folder 引用
用户可显式引用：
- `@docs/requirements.md 帮我 review` → 触发 review skill

### 3. 文件上下文自动加载
当前打开文件自动作为上下文，resource skill 会自动包含。

## 升级 UEE

```bash
# 升级 UEE 仓库本身
cd ~/.uee
git pull origin main

# 全局模式：项目里的 .cursorrules 内容是 entry.md 的副本
# 由于不是引用而是副本，需要重新跑 install 拉新版
cd ~/projects/my-app
~/.uee/install.sh --platform=cursor
```

## 卸载

```bash
cd ~/projects/my-app
~/.uee/uninstall.sh --platform=cursor
```

只删 UEE 写入的 `.cursorrules`，如有 `.bak` 备份会询问恢复。

## 文件组织规则

按 ETHOS 规则，新任务产出放独立目录。Cursor 终端可执行 `mkdir`。

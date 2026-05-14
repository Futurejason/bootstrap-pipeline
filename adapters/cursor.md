# Cursor 平台适配

## 平台特性

- 通过 `.cursorrules` 文件加载规则
- 支持 Settings → Rules for AI 配置
- 终端 + 文件读写可用

## 从 git 克隆后的安装步骤

### 场景 1：直接在 UEE 仓库内使用

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee

# 一键
./setup.sh

# 或手动
cp entry.md .cursorrules
```

打开 Cursor → Open Folder → 选择 uee 目录。

### 场景 2：在你的项目里使用

```bash
cd /path/to/your-project
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cp uee/entry.md .cursorrules
```

### 场景 3：附加常用 skill 到 .cursorrules

Cursor 不支持文件引用，但可拼接：

```bash
cat uee/entry.md > .cursorrules
echo "" >> .cursorrules
echo "---" >> .cursorrules
echo "" >> .cursorrules
cat uee/skills/classify/SKILL.md >> .cursorrules
cat uee/skills/clarify/SKILL.md >> .cursorrules
cat uee/skills/plan/SKILL.md >> .cursorrules
cat uee/skills/review/SKILL.md >> .cursorrules
cat uee/quality-gates/four-dimensions.md >> .cursorrules
```

注意：`.cursorrules` 太大可能影响响应速度，按需选择。

### 场景 4：全局配置（所有项目都生效）

打开 Cursor → Settings → Rules for AI → 粘贴 entry.md 内容。

```bash
# macOS
cat uee/entry.md | pbcopy

# Linux
cat uee/entry.md | xclip -selection clipboard

# Windows (Git Bash)
cat uee/entry.md | clip
```

然后在 Cursor 设置中粘贴即可。

## 验证

1. 重启 Cursor
2. 用 Cmd+L 打开 chat，提问"你好"
3. AI 应进入 UEE 流程

如果没生效：
- 检查 `.cursorrules` 在项目根目录
- 文件内容用 `head -20 .cursorrules` 确认
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
cd /path/to/uee
git pull origin main
cd /path/to/your-project
cp uee/entry.md .cursorrules   # 重新生成
```

## 文件组织规则

按 ETHOS 规则，新任务产出放独立目录。Cursor 终端可执行 `mkdir`。

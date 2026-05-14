# ChatGPT / GPTs 平台适配

## 平台特性

- 通过 GPTs 的 Instructions 加载规则
- 单文件、长度有限（约 8000 字符）
- 不支持本地文件引用
- 无终端能力（除非用 Code Interpreter）

## 从 git 克隆后的使用步骤

由于 ChatGPT 是 Web 平台，"克隆 git 仓库"的意义在于**本地有源文件**，方便复制粘贴到 ChatGPT。

### 步骤 1：克隆仓库（在本地）

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee
```

### 步骤 2：复制 entry.md 内容

```bash
# macOS
cat entry.md | pbcopy

# Linux
cat entry.md | xclip -selection clipboard

# Windows (Git Bash)
cat entry.md | clip

# 任意系统：手动打开 entry.md 全选复制
```

### 步骤 3a：创建 GPT（推荐）

1. 进入 ChatGPT → Explore GPTs → Create
2. 在 Configure → Instructions 字段粘贴（Cmd+V / Ctrl+V）
3. 配置：
   - Name: `Universal Expert Engine`
   - Description: `全能行业专家引擎`
   - Capabilities: 按需开启 Web Browsing / Code Interpreter
4. Save → 在新对话使用

### 步骤 3b：普通对话注入

每次新对话开头粘贴 entry.md 内容作为系统提示。

## Instructions 长度处理

ChatGPT GPTs Instructions 约 8000 字符。如果 entry.md 超长：

```bash
# 截取到「文件引用平台」段之前（macOS）
sed '/^# 文件引用平台的扩展加载/,$d' entry.md | pbcopy

# Linux
sed '/^# 文件引用平台的扩展加载/,$d' entry.md | xclip -selection clipboard

# Windows (Git Bash)
sed '/^# 文件引用平台的扩展加载/,$d' entry.md | clip
```

保留：
- 平台自动检测段
- 引擎核心段
- 9 个 Skill 描述
- 失败处理协议
- 启动行为

删除：
- 文件引用平台的扩展加载（这段对 Web 平台无意义）

## 上传专家身份作为 Knowledge（可选）

GPTs 支持 Knowledge 文件上传：

1. Configure → Knowledge → Upload
2. 上传：
   - `experts/business-consultant.md`
   - `experts/software-engineer.md`
   - `experts/data-analyst.md`
   - 其他你常用的专家身份

GPT 会自动检索这些文件回答。

## 验证

1. 在你的 GPT 里开新对话
2. 提任意问题
3. AI 应按 UEE 流程响应（先 classify）

## 限制和应对

| 限制 | 应对 |
|------|------|
| Instructions 字数限制 | 仅加载核心段，不加载详细 skill |
| 无文件系统 | deliver 用 markdown 输出，让用户手动保存 |
| 无终端 | execute 仅生成代码，不执行 |
| 单对话上下文 | 长项目建议拆成多次对话 |
| Knowledge 检索质量 | 用关键词明确指向某个专家身份 |

## 升级 UEE

```bash
cd /path/to/uee
git pull origin main

# 重新粘贴 Instructions
# macOS
cat entry.md | pbcopy
# Linux
cat entry.md | xclip -selection clipboard
# Windows
cat entry.md | clip

# 进入 GPT → Edit → 替换 Instructions
```

## 文件组织规则

无文件系统时：
- deliver 用清晰 markdown 章节结构
- 让用户自行保存到本地
- 在交付摘要中告知用户哪些应该保存到哪个文件名

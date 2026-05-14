# ChatGPT / GPTs 平台适配

## 平台特性

- 通过 GPTs 的 Instructions 加载规则
- Web 平台，单文件、字数有限（约 8000 字符）
- 不支持本地文件引用
- 无终端能力（除非用 Code Interpreter）

## 使用步骤

ChatGPT 是 Web 平台，不需要在"项目里激活"。准备好 entry.md 内容粘贴到 GPT 的 Instructions 即可。

### 步骤 1：先在本地装好 UEE

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git ~/.uee
```

### 步骤 2：复制 entry.md 内容到剪贴板

```bash
# macOS
cat ~/.uee/entry.md | pbcopy

# Linux
cat ~/.uee/entry.md | xclip -selection clipboard

# Windows (Git Bash)
cat ~/.uee/entry.md | clip
```

### 步骤 3a：创建自定义 GPT（推荐）

1. 进入 ChatGPT → Explore GPTs → Create
2. 在 Configure → Instructions 字段粘贴（Cmd+V / Ctrl+V）
3. 配置：
   - Name: `Universal Expert Engine`
   - Description: `全能行业专家引擎`
   - Capabilities: 按需开启 Web Browsing / Code Interpreter
4. Save

### 步骤 3b：普通对话

每次新对话开头粘贴 entry.md 内容作为系统提示。

## Instructions 长度处理

ChatGPT GPTs Instructions 约 8000 字符。如果 entry.md 超长，截取核心部分：

```bash
# macOS
sed '/^# 文件引用平台的扩展加载/,$d' ~/.uee/entry.md | pbcopy

# Linux
sed '/^# 文件引用平台的扩展加载/,$d' ~/.uee/entry.md | xclip -selection clipboard

# Windows (Git Bash)
sed '/^# 文件引用平台的扩展加载/,$d' ~/.uee/entry.md | clip
```

保留：平台检测、引擎核心、9 个 Skill、失败处理、启动行为
删除：「文件引用平台的扩展加载」段（对 Web 平台无意义）

## 上传专家身份作为 Knowledge（可选）

GPTs 支持 Knowledge 文件上传：

1. Configure → Knowledge → Upload
2. 上传你常用的：
   - `~/.uee/experts/business-consultant.md`
   - `~/.uee/experts/software-engineer.md`
   - `~/.uee/experts/data-analyst.md`

GPT 会自动检索这些文件回答。

## 验证

1. 在你的 GPT 里开新对话
2. 提任意问题
3. AI 应按 UEE 流程响应（先 classify）

## 升级 UEE

```bash
cd ~/.uee
git pull origin main

# 重新粘贴 Instructions
cat ~/.uee/entry.md | pbcopy
# 进入 GPT → Edit → 替换 Instructions
```

## 限制和应对

| 限制 | 应对 |
|------|------|
| Instructions 字数限制 | 仅加载核心段 |
| 无文件系统 | deliver 用 markdown 输出，让用户手动保存 |
| 无终端 | execute 仅生成代码，不执行 |
| 单对话上下文 | 长项目拆成多次对话 |

## 文件组织规则

无文件系统时：
- deliver 用清晰 markdown 章节结构
- 让用户自行保存到本地
- 在交付摘要中告知用户哪些应该保存到哪个文件名

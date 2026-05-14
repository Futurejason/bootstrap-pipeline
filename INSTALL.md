# UEE 安装指南

> 本文档介绍：在新机器/新平台上从 git 克隆本仓库后，如何激活 Universal Expert Engine。

## 第 1 步：克隆仓库

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee
```

之后所有命令都在 `uee/` 目录下执行。

## 第 2 步：选择你的平台

选择你要使用的 AI 平台，按对应步骤操作：

| 平台 | 类型 | 操作复杂度 | 跳转 |
|------|------|----------|------|
| Kiro | IDE，有文件系统，支持文件引用 | ⭐ | [→ Kiro](#kiro) |
| Claude Code | CLI，有终端，支持文件读取 | ⭐ | [→ Claude Code](#claude-code) |
| Cursor | IDE，支持 .cursorrules 单文件 | ⭐⭐ | [→ Cursor](#cursor) |
| Windsurf | IDE，支持 .windsurfrules 单文件 | ⭐⭐ | [→ Windsurf](#windsurf) |
| ChatGPT / GPTs | Web，仅 Instructions 字段 | ⭐⭐⭐ | [→ ChatGPT](#chatgpt) |
| Claude Projects | Web，支持 Knowledge 上传 | ⭐⭐ | [→ Claude](#claude-projects) |

或使用一键脚本：

```bash
./setup.sh
```

脚本会自动检测你的环境并配置。

---

## Kiro

### 适用条件
- 已安装 Kiro IDE
- 想把 UEE 用在某个项目里

### 步骤

1. **决定要在哪个项目使用 UEE**

   情况 A：直接在 UEE 仓库里使用 → 跳到第 2 步

   情况 B：在另一个项目使用 → 把 UEE 克隆到那个项目内：
   ```bash
   cd /path/to/your-other-project
   git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
   ```

2. **创建 steering 文件**

   在项目根目录创建 `.kiro/steering/uee.md`：

   ```bash
   mkdir -p .kiro/steering
   cat > .kiro/steering/uee.md << 'EOF'
   ---
   inclusion: auto
   ---

   # Universal Expert Engine

   #[[file:../../entry.md]]
   #[[file:../../ETHOS.md]]
   #[[file:../../orchestrator/ORCHESTRATOR.md]]
   #[[file:../../orchestrator/routing-rules.md]]
   #[[file:../../quality-gates/four-dimensions.md]]
   #[[file:../../quality-gates/evidence-chain.md]]
   #[[file:../../skills/classify/SKILL.md]]
   #[[file:../../skills/clarify/SKILL.md]]
   #[[file:../../skills/resource/SKILL.md]]
   #[[file:../../skills/plan/SKILL.md]]
   #[[file:../../skills/design/SKILL.md]]
   #[[file:../../skills/execute/SKILL.md]]
   #[[file:../../skills/review/SKILL.md]]
   #[[file:../../skills/deliver/SKILL.md]]
   #[[file:../../skills/refine/SKILL.md]]
   EOF
   ```

   > 路径 `../../` 从 `.kiro/steering/` 出发，向上 2 级到 UEE 仓库根。
   > **如果 UEE 是放在你项目子目录（不是直接在 UEE 仓库工作）**，把 `../../` 改成 `../../uee/`（假设子目录名为 uee）。

3. **重启 Kiro 窗口**（让 steering 生效）

4. **验证**：在 Kiro chat 里输入任意问题，AI 应该按 UEE 流程响应（先 classify，再 clarify ...）。

### 单仓库模式
**直接 clone UEE 后在仓库内使用**：用上面的写法（`../../`）即可。

**在你的项目里嵌套使用 UEE**（推荐做法是建议用户自己 clone 一份）：
- 在你的项目根 clone：`git clone ... uee`
- steering 文件路径改成 `../../uee/...`

---

## Claude Code

### 适用条件
- 已安装 Claude Code CLI
- 项目有终端能力

### 步骤

1. **进入项目目录**（可以是 UEE 仓库或你自己的项目）：
   ```bash
   cd /path/to/your-project
   ```

2. **复制 entry.md 到 CLAUDE.md**：

   情况 A：直接用 UEE 仓库
   ```bash
   cp entry.md CLAUDE.md
   echo "" >> CLAUDE.md
   echo "## 引用文件（按需加载）" >> CLAUDE.md
   echo "" >> CLAUDE.md
   echo "完整规则：见 ETHOS.md / ARCHITECTURE.md / skills/*/SKILL.md / experts/*.md" >> CLAUDE.md
   ```

   情况 B：在另一个项目使用 UEE，先克隆：
   ```bash
   git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
   cp uee/entry.md CLAUDE.md
   ```

3. **启动 Claude Code**：
   ```bash
   claude
   ```

   `CLAUDE.md` 会自动加载。

4. **验证**：随便问一个问题，AI 应该走 UEE 流程。

---

## Cursor

### 适用条件
- 已安装 Cursor IDE

### 步骤

1. **打开你的项目**（可以是 UEE 仓库或你自己的项目）

2. **生成 `.cursorrules`**：

   ```bash
   # 如果在 UEE 仓库内
   cp entry.md .cursorrules

   # 如果在其他项目，先克隆 UEE 再复制
   git clone https://github.com/Futurejason/bootstrap-pipeline.git /tmp/uee
   cp /tmp/uee/entry.md .cursorrules
   ```

3. **重启 Cursor** 让规则生效

4. **验证**：用 Cmd+L 提问，AI 应按 UEE 流程响应

### 进阶：附加常用 skill

Cursor 不支持 `#[[file:]]` 引用，但可以把核心 skill 拼到 .cursorrules 末尾：

```bash
cat entry.md > .cursorrules
echo "" >> .cursorrules
echo "---" >> .cursorrules
cat skills/classify/SKILL.md >> .cursorrules
cat skills/clarify/SKILL.md >> .cursorrules
cat skills/plan/SKILL.md >> .cursorrules
cat skills/review/SKILL.md >> .cursorrules
cat quality-gates/four-dimensions.md >> .cursorrules
```

---

## Windsurf

### 适用条件
- 已安装 Windsurf IDE

### 步骤

操作同 Cursor，把 `.cursorrules` 改成 `.windsurfrules`：

```bash
cp entry.md .windsurfrules
```

---

## ChatGPT

### 适用条件
- 已订阅 ChatGPT Plus（创建 GPTs 需要）
- 或用普通对话模式

### 方式 A：创建自定义 GPT（推荐）

1. 进入 ChatGPT → Explore GPTs → Create
2. 在「Instructions」字段粘贴 `entry.md` 全部内容（约 8000 字符以内）

   如果需要 Instructions 内容：
   ```bash
   # macOS
   cat entry.md | pbcopy

   # Linux
   cat entry.md | xclip -selection clipboard

   # Windows (Git Bash)
   cat entry.md | clip
   ```

3. 配置：
   - Name: `Universal Expert Engine`
   - Description: `全能行业专家引擎`
   - Capabilities: 按需开启 Web Browsing / Code Interpreter

4. **验证**：在新对话提问，AI 应按 UEE 流程响应

### 方式 B：普通对话注入

每次新对话开头粘贴 `entry.md` 内容作为系统提示。

### 限制

- ChatGPT GPTs Instructions 长度限制约 8000 字符
- 如超出，仅保留 entry.md 的「引擎核心」段（删除「平台自动检测」和「完整能力树」段）

---

## Claude Projects

### 适用条件
- Claude.ai 账号

### 步骤

1. **创建 Claude Project**：
   - Claude → Projects → New Project

2. **设置 Project Instructions**：
   - 把 `entry.md` 内容粘贴进去

3. **上传 Knowledge 文件**（可选但推荐）：
   - 上传：`ETHOS.md`、`skills/` 下所有 SKILL.md、`experts/` 下所有专家身份
   - Claude 会自动读取这些文件回答

4. **验证**：在 Project 内开新对话提问

### 限制
- Knowledge 文件数有上限（视订阅版本）
- 无文件系统 → 用 Artifacts 输出长内容

---

## 通用问题

### Q: 我已经在用，但想升级 UEE 到最新版？

```bash
cd /path/to/uee
git pull origin main
```

各平台的配置文件（如 `.cursorrules`、`CLAUDE.md`）需要重新生成：

```bash
cp entry.md .cursorrules        # 或 CLAUDE.md / .windsurfrules
```

ChatGPT/Claude Projects 需要手动重新粘贴 Instructions。

### Q: 怎么验证 UEE 真的生效了？

提问任意问题，AI 应该：
1. 不直接回答，而是先输出 `[classify] domain=... complexity=...`
2. 或在 clarify 阶段提交 P1 决策简报
3. 关键论断带 `【论断】【论据】【来源】【可信度】` 三元组

如果 AI 直接回答没有上述结构，说明 UEE 没生效。检查：
- 配置文件路径是否正确
- IDE 是否已重启
- 文件引用路径是否正确（特别是 Kiro 的相对路径）

### Q: 想关闭 UEE？

- Kiro: 把 `.kiro/steering/uee.md` 顶部 `inclusion: auto` 改成 `inclusion: manual`（之后用 `#uee` 手动触发），或直接删除该文件
- Cursor / Windsurf: 删除 `.cursorrules` / `.windsurfrules`
- Claude Code: 删除 `CLAUDE.md`
- ChatGPT GPTs: 切换到普通 ChatGPT
- Claude Projects: 在普通对话框聊天

### Q: 想只用某个 skill，不走完整流程？

明确告诉 AI 用哪个 skill，例如：
- "用 review skill 检查这份文档"
- "调用 classify 判断复杂度就行"
- "直接给我方案对比（plan skill）"

---

## 部署后检查清单

每个平台部署完后建议跑一遍：

- [ ] 启动/重启 IDE 或新开对话
- [ ] 提问简单问题（"Hello"），AI 应进入 classify
- [ ] 提问复杂问题（"帮我设计 X"），AI 应识别为 L2/L3
- [ ] 验证 P1/P2 用户介入点正常触发
- [ ] 验证 deliver 输出包含质量报告 + 证据链

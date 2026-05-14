# Kiro 平台适配

## 平台特性

- 支持文件引用 `#[[file:path]]`
- 支持 steering（自动加载规则）
- 支持 specs（结构化需求文档）
- 内置 task 工具链

## 从 git 克隆后的安装步骤

### 场景 1：直接在 UEE 仓库内使用

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee

# 一键安装
./setup.sh

# 或手动配置
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

### 场景 2：在你自己的项目里使用 UEE

```bash
# 在你的项目根目录
cd /path/to/your-project
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee

# 一键安装（从 UEE 仓库执行，target 是你的项目）
./uee/setup.sh "$(pwd)"
```

或手动：

```bash
mkdir -p .kiro/steering
cat > .kiro/steering/uee.md << 'EOF'
---
inclusion: auto
---

# Universal Expert Engine

#[[file:../../uee/entry.md]]
#[[file:../../uee/ETHOS.md]]
#[[file:../../uee/orchestrator/ORCHESTRATOR.md]]
#[[file:../../uee/orchestrator/routing-rules.md]]
#[[file:../../uee/quality-gates/four-dimensions.md]]
#[[file:../../uee/quality-gates/evidence-chain.md]]
#[[file:../../uee/skills/classify/SKILL.md]]
#[[file:../../uee/skills/clarify/SKILL.md]]
#[[file:../../uee/skills/resource/SKILL.md]]
#[[file:../../uee/skills/plan/SKILL.md]]
#[[file:../../uee/skills/design/SKILL.md]]
#[[file:../../uee/skills/execute/SKILL.md]]
#[[file:../../uee/skills/review/SKILL.md]]
#[[file:../../uee/skills/deliver/SKILL.md]]
#[[file:../../uee/skills/refine/SKILL.md]]
EOF
```

### 场景 3：手动指定按需引用（manual 模式）

如果不想自动加载，改成手动触发：

```bash
mkdir -p .kiro/skills
cat > .kiro/skills/uee.md << 'EOF'
---
inclusion: manual
---

# UEE — 按需引用

通过 `#uee` 触发引擎。

#[[file:../../uee/entry.md]]
EOF
```

之后在 chat 里用 `#uee` 触发。

## 第 3 步：验证

1. 重启 Kiro 窗口（让 steering 生效）
2. 在 chat 里输入 "你好" 或任意问题
3. AI 应该按 UEE 流程响应：
   - 先输出 `[classify] domain=... complexity=...`
   - 再进入 clarify 阶段（如有不确定项触发 P1）

如果 AI 直接回答没走流程，检查：
- steering 文件路径相对路径是否对（从 `.kiro/steering/` 出发）
- 文件引用语法是否是 `#[[file:...]]`
- Kiro 是否已重启

## Kiro 特有能力利用

### 1. task_list / task_update 工具
L3 流程的多模块执行可拆成 task：
- execute skill 内部把模块拆成 task list
- 用 task_list 工具创建任务
- 逐个 task_update 推进

### 2. invoke_sub_agent
复杂子任务委托：
- plan 中的研究 → context-gatherer sub-agent
- 完整子任务 → general-task-execution sub-agent

### 3. user_input 工具
P1/P2/P3/P4 决策点用 `user_input` 工具，提供结构化选项。

## 文件组织规则

按 ETHOS 规则，每个新任务的产出放在独立 kebab-case 目录：
- 任务文件夹与 .kiro 同级
- 内部 docs/ src/ tests/ 按需

## 升级 UEE

```bash
cd /path/to/uee
git pull origin main
```

steering 文件不需要改（用的相对路径）。

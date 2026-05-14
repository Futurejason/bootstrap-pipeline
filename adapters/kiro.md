# Kiro 平台适配

## 平台特性

- 支持文件引用 `#[[file:path]]`
- 支持 steering（自动加载规则）
- 支持 specs（结构化需求文档）
- 内置 task 工具链

## 加载方式

### 方式 1：通过 steering 自动加载（推荐）

在 `.kiro/steering/` 创建 `uee.md`：

```markdown
---
inclusion: auto
---

# Universal Expert Engine

#[[file:../../universal-expert-engine/entry.md]]
#[[file:../../universal-expert-engine/ETHOS.md]]
#[[file:../../universal-expert-engine/orchestrator/ORCHESTRATOR.md]]
#[[file:../../universal-expert-engine/skills/classify/SKILL.md]]
#[[file:../../universal-expert-engine/skills/clarify/SKILL.md]]
#[[file:../../universal-expert-engine/skills/resource/SKILL.md]]
#[[file:../../universal-expert-engine/skills/plan/SKILL.md]]
#[[file:../../universal-expert-engine/skills/design/SKILL.md]]
#[[file:../../universal-expert-engine/skills/execute/SKILL.md]]
#[[file:../../universal-expert-engine/skills/review/SKILL.md]]
#[[file:../../universal-expert-engine/skills/deliver/SKILL.md]]
#[[file:../../universal-expert-engine/skills/refine/SKILL.md]]
#[[file:../../universal-expert-engine/quality-gates/four-dimensions.md]]
#[[file:../../universal-expert-engine/quality-gates/evidence-chain.md]]
```

### 方式 2：通过 skill 按需引用

在 `.kiro/skills/` 创建 `uee.md`：

```markdown
---
inclusion: manual
---

# UEE — 按需引用

通过 `#uee` 触发引擎。

#[[file:../../universal-expert-engine/entry.md]]
```

## Kiro 特有能力利用

### 1. 利用 task_list / task_update 工具

L3 流程的多模块执行可以拆成 task：

```
execute skill 内部：
1. 把模块拆成 task list
2. 用 task_list 工具创建任务
3. 逐个 task_update 推进
4. 最后汇总
```

### 2. 利用 invoke_sub_agent

复杂子任务可以委托给 sub-agent：

```
plan skill 内部：
- 复杂的方案研究 → invoke_sub_agent(name="context-gatherer")
- 完整子任务 → invoke_sub_agent(name="general-task-execution")
```

### 3. 利用 user_input 工具

P1/P2/P3/P4 决策点用 `user_input` 工具，提供结构化选项：

```python
user_input({
  "question": "**决策标题**",
  "reason": "general-question",
  "options": [
    {"title": "选项 A", "description": "...", "recommended": true},
    {"title": "选项 B", "description": "..."}
  ]
})
```

### 4. 利用 createHook

特定场景可创建 hook，比如：
- file 修改后自动跑 review
- 任务完成后自动跑 deliver

## Kiro 文件组织规则

按 ETHOS 规则，每个新任务的产出放在独立 kebab-case 目录。
- 任务文件夹与 .kiro 同级
- 内部 docs/ src/ tests/ 按需

## 不支持的能力

无明显限制。Kiro 是 UEE 的最佳运行环境。

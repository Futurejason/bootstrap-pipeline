---
name: deliver
version: 1.0.0
description: 交付包装。把零散产出包装成可交付物（含证据链 + 质量报告）。
triggers:
  - 打包交付
  - 整理最终结果
  - 给我交付物
required-quality-gates: [completeness, accuracy]
---

# Skill: deliver — 交付包装

## 能做什么

- 整合 execute 的产出和 review 的评分
- 输出标准化的最终交付包
- 提交 P4 用户验收
- 生成证据链汇总和质量报告

## 不能做什么

- 不修改产出内容（属于 refine）
- 不做新的质量评估（属于 review）

## 输入规范

```yaml
input:
  execute_output: object
  review_output: object
  classify_output: object  # 用于回顾原始问题
  clarify_output: object   # 用于回顾理解
  expert: string
```

## 执行步骤

### Step 1: 决定交付目录（如平台支持文件系统）

按 ETHOS 文件组织规则：
- 新建 `<task-name>/` 目录（kebab-case）
- 内部按 `docs/`、`src/`、`tests/` 等组织

如果平台不支持文件系统（如 ChatGPT），改为输出完整 markdown 内容。

### Step 2: 生成交付包

```markdown
# [问题主题] — 解决方案

## 摘要
- 原始问题：[一句话]
- 采用方案：[方案名]
- 关键决策：[2-3 条]
- 整体可信度：✅确定 / 🔶高度可能 / ⚠️推测
- 完成时间：[实际耗时]

## 主体产出

[execute 的最终产出物]

## 质量报告

### 评分
| 维度 | 分数 | 通过线 | 状态 |
|------|------|--------|------|
| 完备性 | 9/10 | 8 | ✅ |
| 准确性 | 8/10 | 8 | ✅ |
| 一致性 | 9/10 | 7 | ✅ |
| 可行性 | 9/10 | 7 | ✅ |

### 已覆盖项
- ...

### 已知局限
- [局限 1]：[原因] | [影响]
- [局限 2]：[原因] | [影响]

### 对抗性自检（已识别但未修复的潜在问题）
- ...

## 证据链汇总

| # | 论断 | 来源 | 可信度 |
|---|------|------|--------|
| 1 | ... | ... | ✅ |
| 2 | ... | ... | 🔶 |

## 决策记录

整个流程中做出的关键决策：
| # | 决策点 | 选项 | 选择 | 理由 |
|---|-------|------|------|------|
| 1 | ... | A/B/C | A | ... |

## 后续建议

### 立即可做
- ...

### 需要用户验证的假设
- ...

### 可选优化（未做但可加）
- ...
```

### Step 3: 提交 P4 验收

```
🟢 P4 — 验收

我已完成交付，请检查：

【主要产出】[简述]
【质量评分】完备性 X/10 / 准确性 X/10 / 一致性 X/10 / 可行性 X/10
【已知局限】[列出]

请验收：
- 回复 "通过" / "OK" → 交付完成
- 回复具体修改意见 → 进入 refine 阶段
- 回复 "整体重做" → 回退到 plan 重新选方案

默认行为（你不响应时）：等待你回复
```

## 输出规范

```yaml
skill: deliver
version: 1.0.0
status: AWAITING_ACCEPTANCE
output:
  delivery_path: "<task-name>/"  # 或 markdown 内容
  summary:
    original_question: "..."
    chosen_plan: "..."
    key_decisions: [...]
    overall_confidence: "✅"
    actual_time: "..."
  main_artifact: "..."
  quality_report:
    scores: {...}
    covered_items: [...]
    known_limitations: [...]
  evidence_chain: [...]
  decision_log: [...]
  recommendations: [...]
quality_score:
  completeness: 10
  accuracy: 10
  consistency: 10
  feasibility: 10
next_skill:
  if_user_accepts: END
  if_user_requests_changes: refine
```

## 质量门要求

- **完备性**：交付包结构完整 → ≥ 10
- **准确性**：质量报告与 review 输出一致 → ≥ 10

## 单独使用模式

用户说"把这些零散的输出打包" → 整合输出，但跳过 P4（用户已经手动接管）。

## 整体使用模式

review PASSED 后调用，等待用户验收。

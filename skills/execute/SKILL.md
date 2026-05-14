---
name: execute
version: 1.0.0
description: 执行产出。根据方案直接产出最终结果（代码/文档/分析/报告）。
triggers:
  - 开始做
  - 直接执行
  - 给我成品
required-quality-gates: [completeness, accuracy, feasibility]
---

# Skill: execute — 执行产出

## 能做什么

- 根据上游方案/设计直接产出实际成果
- 按子模块拆分逐步执行
- 每完成一块自检后继续
- 失败时暴露问题、不静默继续

## 不能做什么

- 不重新设计（属于 design / plan）
- 不做最终质量评分（属于 review）

## 输入规范

```yaml
input:
  plan_output: object
  design_output: object  # L3 才有
  resource_output: object
  expert: string
```

## 执行步骤

### Step 1: 实施计划陈述

执行前先输出：
```
## 实施计划

1. [步骤] → 验证：[具体检查项]
2. [步骤] → 验证：[具体检查项]
...
预计耗时：[X 分钟/小时]
```

### Step 2: 按模块逐步执行

对每个子模块：

```
### 执行：[模块名]

【做了什么】
[具体输出，可能是代码块/文档段/分析片段]

【验证】
- [检查项 1]：✅ / ❌
- [检查项 2]：✅ / ❌

【证据链】
- 论据：[做这个选择的事实依据]
- 来源：[官方文档/逻辑推导]
- 可信度：✅
```

### Step 3: 处理执行中的问题

发现与方案不符的情况：
- 立即暂停
- 说明：「方案中假设 X，但实际发现 Y」
- 影响评估
- 提供选项：调整方案 / 按现状继续 / 上报阻塞

### Step 4: 模块汇总

```
## 模块 X 完成
- 完成内容：
- 与设计文档对应：
- 遇到的问题及处理：
```

### Step 5: 整体产出汇总

所有模块完成后输出：
- 最终产出物（一份完整的代码/文档/方案）
- 所有模块的对应关系

## 执行规范（重要）

### 软件代码场景
- Python：uv 管理依赖，完整类型注解
- TypeScript：pnpm，strict: true
- 只实现需求中明确要求的功能（不投机性扩展）
- 只修改必须修改的代码（不顺手重构）

### 文档/方案场景
- 用 markdown 结构化
- 长文档配置目录
- 每个论断附证据链

### 数据分析场景
- 计算过程可追溯
- 结论与数据匹配
- 异常值标注

## 输出规范

```yaml
skill: execute
version: 1.0.0
status: DONE | DONE_WITH_CONCERNS | BLOCKED
output:
  implementation_plan: "..."
  modules:
    - name: "..."
      output: "..."
      verifications: [...]
      issues: [...]
  final_deliverable: "完整产出物"
  total_time: "..."
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 8
  feasibility: 9
next_skill: review
```

## 质量门要求

- **完备性**：方案中所有模块都执行了 → ≥ 9
- **准确性**：执行内容与方案一致 → ≥ 9
- **可行性**：产出物可直接使用 → ≥ 9

## 失败处理

### 单步执行失败
- 第 1 次：换方法重试
- 第 2 次：暴露错误细节，再尝试
- 第 3 次：切备选方案

### 备选耗尽
- 简化交付（明确说明哪些做了/哪些没做）
- 进入 DONE_WITH_CONCERNS 状态

## 单独使用模式

用户说"按这个方案直接执行" → 跑 execute 输出最终产出。

## 整体使用模式

调用 review 做质量评分，通过后进入 deliver。

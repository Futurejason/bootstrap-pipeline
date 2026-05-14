---
name: plan
version: 1.0.0
description: 方案设计与对比。给出 1-3 个可执行方案并推荐。
triggers:
  - 给我几个方案
  - 对比方案
  - 怎么做
required-quality-gates: [completeness, accuracy, feasibility]
---

# Skill: plan — 方案设计与对比

## 能做什么

- 基于澄清后的需求和资源分析，生成 1-3 个候选方案
- 评估每个方案的可行性
- 输出对比表
- 推荐方案并说明理由
- 触发 P2 用户确认

## 不能做什么

- 不做详细设计（属于 design skill，仅 L3）
- 不直接执行（属于 execute skill）

## 输入规范

```yaml
input:
  clarify_output: object
  resource_output: object  # L2/L3 必有，L1 跳过本 skill
  expert: string
```

## 执行步骤

### Step 1: 生成候选方案

每个方案包含：
- **名称**：简洁描述
- **核心思路**：一句话
- **执行步骤**：3-7 步
- **产出物**：具体清单
- **预估投入**：时间 + 资源
- **适用场景**：什么情况下选这个

数量原则：
- 简单问题 → 1 个方案（直接给最优解）
- 中等问题 → 2 个方案（保守 vs 激进）
- 复杂问题 → 3 个方案（保守 / 平衡 / 激进）

### Step 2: 可行性评分

每个方案在 4 个维度打分（1-10）：

| 维度 | 含义 |
|------|------|
| 复杂度 | 实施难度（分数高=难度低） |
| 资源完备度 | 现有资源是否足够（分数高=资源充足） |
| 预期效果 | 解决问题的程度（分数高=效果好） |
| 风险可控性 | 失败风险大小（分数高=风险低） |

### Step 3: 生成对比表

```
| 维度 | 方案 A | 方案 B | 方案 C |
|------|--------|--------|--------|
| 复杂度 | 7/10 | 9/10 | 5/10 |
| 资源完备度 | 8/10 | 9/10 | 6/10 |
| 预期效果 | 9/10 | 7/10 | 10/10 |
| 风险可控性 | 7/10 | 9/10 | 6/10 |
| 综合 | 7.75 | 8.5 | 6.75 |
| 时间 | 1周 | 3天 | 2周 |
| 适合场景 | 平衡 | 快速验证 | 追求最优 |
```

### Step 4: 推荐及理由

```
## 推荐方案：方案 B

理由：
1. [具体理由 1]
2. [具体理由 2]
3. [具体理由 3]

【证据链】
- 论据：综合评分 8.5 最高
- 来源：上述对比表
- 可信度：✅
```

### Step 5: 提交 P2 决策简报

```
🔵 P2 — 请选择方案

我已生成 3 个候选方案，推荐方案 B（理由：综合评分最高、风险可控）。

如何选择：
- 回复 "方案 A" / "方案 B" / "方案 C"
- 回复 "用推荐的" → 采用方案 B
- 回复 "都不满意，重新设计" → 我会调整方向

默认行为（你不响应时）：采用推荐方案 B
```

## 输出规范

```yaml
skill: plan
version: 1.0.0
status: AWAITING_USER_CHOICE
output:
  candidates:
    - id: A
      name: "..."
      idea: "..."
      steps: [...]
      deliverables: [...]
      estimated_effort: "..."
      scenario: "..."
      scores:
        complexity: 7
        resource: 8
        effect: 9
        risk: 7
        overall: 7.75
    - id: B
      ...
  comparison_table: "markdown table"
  recommendation: B
  recommendation_reason: "..."
quality_score:
  completeness: 9
  accuracy: 8
  consistency: 9
  feasibility: 9
next_skill:
  if_user_chooses: design (L3) | execute (L1/L2)
  if_user_rejects_all: REPLAN
```

## 质量门要求

- **完备性**：方案要素完整（思路/步骤/产出/投入/场景）→ ≥ 9
- **准确性**：评分有依据 → ≥ 8
- **可行性**：方案在约束内能执行 → ≥ 8

## 失败处理

### 用户不满意所有方案
→ 询问偏好方向 → 重新生成方案（最多 2 次）→ 仍不满意则上报需要更多信息

### 方案间差异不明显
→ 合并为 1-2 个方案，避免假对比

## 单独使用模式

用户说"给我 3 个开店方案" → 直接生成方案对比。

## 整体使用模式

L2/L3 必经，用户确认后 → design（L3）或 execute（L2）。
L1 跳过本 skill。

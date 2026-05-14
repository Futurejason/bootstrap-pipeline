---
name: review
version: 1.0.0
description: 自检与质量门。对任何产出做四维评分 + 改进建议。
triggers:
  - 检查质量
  - 评分
  - 给我review一下
required-quality-gates: []  # review 自身不做质量门，是质量门的执行者
---

# Skill: review — 自检与质量门

## 能做什么

- 对任何产出做四维质量评分（完备性/准确性/一致性/可行性）
- 给具体改进建议
- 做对抗性自检（"换我是用户/对手会挑哪些刺"）
- 决定是否通过质量门

## 不能做什么

- 不直接修改产出（属于 refine skill）
- 不重新执行（属于 execute skill）

## 输入规范

```yaml
input:
  artifact: any            # 待评审的产出物
  artifact_type: code | doc | plan | analysis | other
  context: object          # 上游 skill 的输出（用于一致性比对）
  required_score: 7-10     # 通过线，默认 8
```

## 执行步骤

### Step 1: 四维评分

#### 完备性（Completeness）
检查项：
- [ ] 所有要求覆盖？
- [ ] 边界场景考虑？
- [ ] 异常处理？
- [ ] 必要的依赖说明？

打分依据：覆盖项 / 总要求项 × 10

#### 准确性（Accuracy）
检查项：
- [ ] 论断有证据链？
- [ ] 来源真实可查？
- [ ] 数字/数据正确？
- [ ] 没有事实错误？

打分依据：有证据论断 / 总论断 × 10

#### 一致性（Consistency）
检查项：
- [ ] 与上游方案一致？
- [ ] 内部不矛盾？
- [ ] 术语统一？
- [ ] 风格统一？

打分依据：一致项 / 总检查项 × 10

#### 可行性（Feasibility）
检查项：
- [ ] 在约束内可执行？
- [ ] 资源足够？
- [ ] 步骤可操作？
- [ ] 风险可控？

打分依据：可行项 / 总检查项 × 10

### Step 2: 对抗性自检

模拟以下角色，挑刺：
- **用户**：实际用起来会遇到什么问题？
- **对手/竞品**：会从哪里攻击？
- **未来的我**：6 个月后维护时会骂哪里？
- **新手**：哪里看不懂？

输出至少 3 条挑刺意见。

### Step 3: 输出评分报告

```
## 质量评分

| 维度 | 分数 | 通过线 | 状态 | 关键问题 |
|------|------|--------|------|---------|
| 完备性 | 9/10 | 8 | ✅ | 缺少错误处理示例 |
| 准确性 | 8/10 | 8 | ✅ | 1 处证据链不完整 |
| 一致性 | 7/10 | 7 | ✅ | 术语略有混用 |
| 可行性 | 9/10 | 7 | ✅ | - |

综合：✅ 通过 / ⚠️ 警告 / ❌ 不通过

## 对抗性自检发现
1. [挑刺 1]
2. [挑刺 2]
3. [挑刺 3]

## 改进建议（优先级排序）
- P0：[必须改的]
- P1：[建议改的]
- P2：[可选改的]
```

### Step 4: 通过判定

- 4 维都 ≥ 通过线 → status: PASSED
- 任一维度 < 通过线但差距 ≤ 2 → status: PASSED_WITH_NOTES
- 任一维度 < 通过线且差距 > 2 → status: FAILED

## 输出规范

```yaml
skill: review
version: 1.0.0
status: PASSED | PASSED_WITH_NOTES | FAILED
output:
  scores:
    completeness: 9
    accuracy: 8
    consistency: 7
    feasibility: 9
  pass_lines:
    completeness: 8
    accuracy: 8
    consistency: 7
    feasibility: 7
  adversarial_findings:
    - "..."
  improvements:
    p0: [...]
    p1: [...]
    p2: [...]
  decision: PASS | RETRY | DOWNGRADE
quality_score:
  # review 自己的输出也要打分
  completeness: 9
  accuracy: 10
  consistency: 9
  feasibility: 10
next_action:
  if_PASSED: deliver
  if_PASSED_WITH_NOTES: deliver_with_concerns
  if_FAILED: refine | execute_retry
```

## 失败处理

### 评分主观性高
- 公开评分依据（每项的检查清单和判分理由）
- 用户可挑战某项分数 → 重评

### 反复 FAILED
- 第 1 次失败：返回 execute 重做
- 第 2 次失败：触发 plan 重新选方案
- 第 3 次失败：切备选方案 + DOWNGRADE 简化交付

## 单独使用模式

用户说"帮我 review 这份文档" → 仅输出评分报告，不修改原文。

## 整体使用模式

被 execute 后调用，决定流程下一步：
- PASSED → deliver
- FAILED → refine 或 execute 重试

---
name: refine
version: 1.0.0
description: 反馈优化。根据用户验收反馈定向修改产出。
triggers:
  - 修改这部分
  - 优化一下
  - 这里不对
required-quality-gates: [completeness, accuracy, consistency]
---

# Skill: refine — 反馈优化

## 能做什么

- 解析用户反馈，识别要改的部分
- 定向修改（外科手术式，不动其他部分）
- 重跑相关质量门
- 输出变更说明

## 不能做什么

- 不全盘重做（如果用户要求重做，应回退到 plan）
- 不擅自扩展（用户没要求的不动）

## 输入规范

```yaml
input:
  original_artifact: object  # 上次 deliver 的产出
  user_feedback: string      # 用户的反馈意见
  context:
    classify_output: object
    plan_output: object
    execute_output: object
    review_output: object
```

## 执行步骤

### Step 1: 解析反馈

将用户反馈分类：
- **明确修改**："把 X 改成 Y"
- **方向调整**："这部分太复杂了，简化一下"
- **范围扩展**："加上 Z"
- **整体不满**："不喜欢，重做"（→ 应回退到 plan）

### Step 2: 影响范围分析

每个修改点：
- 影响哪些章节/模块/字段
- 是否触发其他部分的连锁修改
- 是否需要重跑某个上游 skill

### Step 3: 列出修改清单

```
## 修改清单

| # | 反馈 | 影响范围 | 修改策略 |
|---|------|---------|---------|
| 1 | [反馈] | [文件/章节] | 修改 |
| 2 | [反馈] | [模块] | 重新生成 |
| 3 | [反馈] | 多处 | 重跑 plan |
```

### Step 4: 执行修改

对每个修改点：
- 定位精确位置
- 仅修改必要内容
- 不顺手改无关部分（外科手术原则）

### Step 5: 自检 + 重跑质量门

修改后必须：
- 重跑 review 4 维评分
- 检查与上下文的一致性
- 确认没破坏其他部分

### Step 6: 输出变更说明

```
## 变更说明

### 已修改
1. [文件/章节]：[改前 → 改后] | 理由：[反馈对应]
2. ...

### 未修改（说明原因）
- [反馈项]：[为什么不改] | 替代方案：[如果有]

### 涉及连锁修改
- [关联部分]：[同步更新内容]

### 重新评分
| 维度 | 修改前 | 修改后 |
|------|--------|--------|
| 完备性 | 9 | 9 |
| 准确性 | 8 | 9 |
...
```

## 输出规范

```yaml
skill: refine
version: 1.0.0
status: DONE | DONE_WITH_CONCERNS | NEEDS_REPLAN
output:
  changes:
    modified:
      - location: "..."
        before: "..."
        after: "..."
        reason: "..."
    not_modified:
      - feedback: "..."
        reason: "..."
        alternative: "..."
    cascading_changes: [...]
  rescore:
    before: {...}
    after: {...}
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 9
  feasibility: 9
next_skill:
  if_DONE: deliver  # 重新交付一次
  if_NEEDS_REPLAN: plan
```

## 质量门要求

- **完备性**：用户反馈每条都回应了 → ≥ 9
- **准确性**：修改与反馈对应 → ≥ 9
- **一致性**：修改后整体一致 → ≥ 9

## 失败处理

### 反馈太模糊无法定位
→ 回 P3 阻塞决策让用户具体化

### 修改触发大范围连锁问题
→ 上报 → 询问是否回退到 plan 重新规划

### 用户反馈互相矛盾
→ 列出矛盾点 → 让用户排序优先级

## 单独使用模式

用户说"把这份文档的 X 部分改成 Y" → 直接定向修改，输出变更说明。

## 整体使用模式

deliver 后用户提反馈 → 调用 refine → 完成后再次 deliver（轮询直到验收通过）。

## 关键原则

1. **外科手术式**：只动该动的，不顺手改
2. **明示未做的**：用户提的但没做的事必须说明原因
3. **重跑质量门**：修改后必须重新评分

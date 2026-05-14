---
name: clarify
version: 1.0.0
description: 问题澄清与理解确认。把模糊问题变清晰，识别不确定项。
triggers:
  - 帮我整理需求
  - 澄清问题
  - 我没说清楚
required-quality-gates: [completeness, accuracy, consistency]
---

# Skill: clarify — 问题澄清

## 能做什么

- 复述对用户问题的理解
- 识别问题中的不确定项
- 区分阻塞性 vs 非阻塞性不确定
- 阻塞性 → 提交 P1 决策简报让用户决定
- 非阻塞 → 标注默认值后继续

## 不能做什么

- 不分析资料（属于 resource skill）
- 不给方案（属于 plan skill）

## 输入规范

```yaml
input:
  user_question: string
  classify_output: object  # 来自 classify skill
  expert_loaded: string    # 已加载的专家身份
  context: string
```

## 执行步骤

### Step 1: 复述理解

输出格式：
```
## 我的理解

[把用户问题用自己的话复述一遍，一段话]

核心目标：[一句话]
预期产出：[形态]
约束条件：[列出已知约束]
```

### Step 2: 列出当前假设

```
## 当前假设（不确定的地方）

- 假设 1：[描述]
- 假设 2：[描述]

如果以上理解有误，请纠正。
```

### Step 3: 识别不确定项

按阻塞性分类：

**阻塞性**：影响核心方案选择，必须用户决定
- 缺关键信息（预算/时间/范围）
- 多种解读且差异大
- 用户偏好相关（风格/方向）

**非阻塞性**：影响细节但可推测，AI 自己选默认值
- 技术选型的小差异
- 文档格式偏好
- 边界场景的处理

### Step 4: 生成 P1 决策简报（仅当有阻塞性不确定）

每个阻塞性不确定项一份简报：

```
🔵 D1 — [问题标题]

情境：[一句话背景]
通俗解释：[让非专业用户也能理解的说明，2-3 句]
不清楚的地方：[具体描述]
影响范围：[影响哪些后续决策]

选项 A：[描述]（推荐）
  ✅ 优点 1（≥40字符的具体描述）
  ✅ 优点 2
  ❌ 缺点

选项 B：[描述]
  ✅ 优点 1
  ✅ 优点 2
  ❌ 缺点

推荐：选项 A，理由：[一句话]

默认行为（不响应时）：等待你回复
```

### Step 5: 标注非阻塞默认

```
## 已采用默认值的非阻塞项

- 假设 X：默认 [选项] | 理由：[行业惯例/最常见做法]
- 假设 Y：默认 [选项] | 理由：[依据]

如需调整，告诉我即可。
```

### Step 6: 输出汇总

如果有阻塞性 → status: NEEDS_INPUT
否则 → status: DONE

## 输出规范

```yaml
skill: clarify
version: 1.0.0
status: DONE | NEEDS_INPUT
output:
  understanding: "复述的理解"
  goal: "核心目标"
  output_form: "预期产出形态"
  constraints:
    - "时间：1 周"
    - "预算：5 万"
  blocking_uncertainties:
    - id: D1
      title: "..."
      options: [...]
      recommendation: A
  non_blocking_defaults:
    - assumption: "..."
      default: "..."
      reason: "..."
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 8
  feasibility: 10
next_skill:
  if_DONE: resource | plan | execute  # 取决于 complexity
  if_NEEDS_INPUT: WAIT_USER
```

## 质量门要求

- **完备性**：不确定项是否全部识别 → ≥ 8
- **准确性**：理解复述是否准确 → ≥ 8
- **一致性**：与原问题/上下文是否一致 → ≥ 7

## 失败处理

### 用户没回复 P1 决策简报
- 等待响应，不推进
- 用户说"用推荐的"→ 采用推荐选项继续

### 复述理解被用户否定
- 接受纠正 → 重新跑 Step 1-3
- 最多重跑 2 次仍不对 → 上报：「我对你的问题仍有理解偏差，请提供更多上下文」

## 单独使用模式

用户说"帮我整理这个想法的需求" → 跑完 clarify 输出结果，不进入下一阶段。

## 整体使用模式

由 orchestrator 调用，输出传给：
- L1 流程 → execute
- L2/L3 流程 → resource

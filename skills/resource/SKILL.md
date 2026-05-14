---
name: resource
version: 1.0.0
description: 资源分析与约束识别。提取需求、约束、缺失项。
triggers:
  - 分析这些资料
  - 整理资源
  - 看看我提供的文档
required-quality-gates: [completeness, accuracy, consistency]
---

# Skill: resource — 资源分析

## 能做什么

- 逐项分析用户提供的资源（文件、链接、对话历史）
- 提取明确需求、隐含需求、约束条件
- 识别缺失信息及其影响
- 整理为结构化清单

## 不能做什么

- 不澄清模糊问题（属于 clarify）
- 不设计方案（属于 plan）

## 输入规范

```yaml
input:
  user_provided_files: list  # 文件路径或内容
  user_provided_links: list
  conversation_context: string
  clarify_output: object     # 来自 clarify skill
```

## 执行步骤

### Step 1: 逐项分析资源

对每个资源：
- 类型识别（PDF/Markdown/截图/链接/对话）
- 内容摘要
- 关联到 clarify 中的目标和约束

### Step 2: 提取信息

按三类整理：

#### 明确需求（用户直接表达的）
- 来源：[文件/对话片段]
- 内容：[具体需求]

#### 隐含需求（基于上下文推断的）
- 来源：[推断依据]
- 内容：[推断的需求]
- 标注：⚠️ 推测，需用户确认

#### 约束条件
- 时间约束：
- 预算约束：
- 技术栈约束：
- 合规约束：
- 其他约束：

### Step 3: 识别缺失信息

```
## 缺失信息及影响

| 缺失项 | 对方案的影响 | 严重度 |
|--------|------------|--------|
| 目标用户画像 | 影响功能优先级 | 高 |
| 性能要求 | 影响技术选型 | 中 |
```

### Step 4: 决定是否需要补充

- 严重度高 → 转化为阻塞性问题，提交 P3 决策简报
- 严重度中/低 → 标注默认假设后继续

### Step 5: 整合输出

## 输出规范

```yaml
skill: resource
version: 1.0.0
status: DONE | NEEDS_INPUT
output:
  resources_analyzed:
    - source: "file1.pdf"
      type: PDF
      summary: "..."
      key_extracts: [...]
  explicit_requirements: [...]
  implicit_requirements:
    - content: "..."
      inferred_from: "..."
      confidence: "🔶"
  constraints:
    time: "..."
    budget: "..."
    tech_stack: "..."
    compliance: "..."
    others: [...]
  missing_info:
    - item: "..."
      impact: "..."
      severity: high | medium | low
      action: "ask_user | use_default"
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 8
  feasibility: 10
next_skill:
  if_DONE: plan
  if_NEEDS_INPUT: WAIT_USER
```

## 质量门要求

- **完备性**：所有提供的资源都分析了 → ≥ 9
- **准确性**：信息提取准确无臆想 → ≥ 8
- **一致性**：与 clarify 输出一致 → ≥ 8

## 失败处理

### 资源无法访问/读取
→ 上报具体哪个资源失败 + 影响 + 是否能用其他资源替代

### 资源内容矛盾
→ 列出矛盾点 → P3 阻塞决策让用户裁决

## 单独使用模式

用户说"帮我分析这些文档" → 仅输出资源分析结果。

## 整体使用模式

L2/L3 流程必经，输出传给 plan。L1 流程不调用此 skill。

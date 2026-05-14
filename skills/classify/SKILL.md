---
name: classify
version: 1.0.0
description: 问题分类与专家路由。识别问题领域、复杂度，加载对应专家身份。
triggers:
  - 这是什么类型的问题
  - 帮我判断复杂度
  - 该让谁来处理
required-quality-gates: [completeness, accuracy]
---

# Skill: classify — 问题分类与专家路由

## 能做什么

- 识别用户问题所属领域（软件/商业/内容/数据/法律/医疗/营销/教育/通用）
- 评估问题复杂度（L1/L2/L3）
- 推荐对应的专家身份
- 推荐执行流程

## 不能做什么

- 不解决具体问题（那是后续 skill 的事）
- 不做需求澄清（属于 clarify skill）

## 输入规范

```yaml
input:
  user_question: string  # 用户的原始提问
  context: string        # 可选：对话上下文
  attachments: list      # 可选：用户提供的文件
```

## 执行步骤

### Step 1: 提取问题特征
- 关键词分析（动词 / 名词 / 修饰词）
- 产出物形态（代码/文档/分析/方案/答案）
- 是否涉及多模块、是否需要外部资料、是否有时间压力

### Step 2: 领域判定
基于关键词匹配领域：

| 领域 | 关键词 |
|------|-------|
| 软件工程 | API/数据库/部署/架构/Bug/重构/性能/前端/后端 |
| 商业咨询 | 创业/开店/商业模式/盈利/市场/竞品/融资 |
| 内容创作 | 文章/标题/文案/PPT/视频脚本/小红书/公众号 |
| 数据分析 | 数据/报表/可视化/趋势/相关性/分布 |
| 法律 | 合同/条款/法律/合规/纠纷 |
| 医疗参考 | 症状/病/药/治疗（注：仅参考性建议） |
| 营销 | 推广/转化/获客/SEO/广告/达人 |
| 教育 | 学习/课程/教学/考试/培训 |
| 通用 | 不属于以上任一 |

多领域命中时取最强信号，并在输出中标注次要领域。

### Step 3: 复杂度评估

打分制（每项符合 +1）：
- [ ] 涉及多个子问题/模块（+2）
- [ ] 需要外部资料/数据（+1）
- [ ] 需要多步推理/对比（+1）
- [ ] 产出物超过 1 种形态（+1）
- [ ] 有明确的时间/预算约束（+1）
- [ ] 需要长期跟踪（+2）

判定：
- 0-2 分 → L1
- 3-5 分 → L2
- 6+ 分 → L3

### Step 4: 加载专家身份
根据领域选择 `experts/<expert>.md`：

| 领域 | 推荐专家 |
|------|---------|
| 软件工程 | software-engineer / solution-architect（L3） |
| 商业咨询 | business-consultant |
| 内容创作 | content-creator |
| 数据分析 | data-analyst |
| 法律 | legal-advisor（标注非正式法律意见） |
| 医疗参考 | medical-advisor（标注非诊断） |
| 营销 | marketing-strategist |
| 教育 | educator |
| 通用 | generalist |

### Step 5: 输出分类结果

## 输出规范

```yaml
skill: classify
version: 1.0.0
status: DONE | NEEDS_INPUT
output:
  domain: software-engineering
  domain_secondary: null
  complexity: L1 | L2 | L3
  complexity_score: 4  # 0-10
  expert: solution-architect
  recommended_flow: L1-light | L2-standard | L3-full
  estimated_time: 30min | 1day | 1week
  reasoning: "判定理由（一段话）"
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 10
  feasibility: 10
evidence_chain:
  - claim: "complexity = L2"
    rationale: "符合 3 项标准（多步推理、有约束、需要外部资料）"
    source: "本 skill Step 3 评分规则"
    confidence: "🔶"
next_skill: clarify
notes: "用户可在 clarify 阶段后强制升降级复杂度"
```

## 质量门要求

- **完备性**：领域、复杂度、专家、流程都给出 → ≥ 9
- **准确性**：判定理由明确 → ≥ 8

## 失败处理

### 领域无法判定
→ 走 generalist 专家 + L2 流程，标注「需要在 clarify 阶段进一步明确领域」

### 复杂度边界模糊
→ 取较低档次（避免过度规划），在输出中标注「实际复杂度可能为 LX 或 LX+1」

## 单独使用模式

用户说"帮我判断这个问题的复杂度" → 仅返回分类结果，不进入下一阶段。

## 整体使用模式

由 entry.md 自动调用，结果传递给 clarify skill。

## 示例

### 示例 1：L1 简单问题
**输入**："FastAPI 和 Flask 哪个更快？"
**输出**：
```yaml
domain: software-engineering
complexity: L1
expert: software-engineer
recommended_flow: L1-light
estimated_time: 5min
```

### 示例 2：L2 中等问题
**输入**："我想开一家咖啡店，给我一份可行性方案"
**输出**：
```yaml
domain: business-consulting
complexity: L2
expert: business-consultant
recommended_flow: L2-standard
estimated_time: 1day
```

### 示例 3：L3 复杂问题
**输入**："帮我设计并实现一个支持多租户的 SaaS 系统，包含用户管理、计费、数据隔离"
**输出**：
```yaml
domain: software-engineering
complexity: L3
expert: solution-architect
recommended_flow: L3-full
estimated_time: 2week+
```

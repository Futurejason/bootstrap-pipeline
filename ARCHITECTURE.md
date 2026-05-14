# UEE 架构设计

## 1. 设计目标

让 AI 自主解决任何领域的问题，用户仅在 4 个关键节点参与。

满足三个使用场景：
- **整体使用**：用户提问 → AI 闭环交付
- **单 skill 使用**：用户直接调用某个能力（如 review）
- **跨平台使用**：在 Kiro/Cursor/ChatGPT 等平台都能运行

## 2. 双层架构

```
┌─────────────────────────────────────────────────────────┐
│                    Layer 1: Entry                        │
│  entry.md（自包含路由 + 平台检测）                        │
└─────────────────────┬───────────────────────────────────┘
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
┌──────────────────┐       ┌────────────────────┐
│ Orchestrator     │       │ Direct Skill Call  │
│ 整体流程编排      │       │ 单 skill 直用      │
└────────┬─────────┘       └─────────┬──────────┘
         │                           │
         ▼                           ▼
┌──────────────────────────────────────────────────────┐
│              Layer 2: Skills（9 个独立能力）           │
│  classify / clarify / resource / plan / design       │
│  execute / review / deliver / refine                 │
└──────────┬───────────────────────────────────────────┘
           │ 每个 skill 调用
           ▼
┌──────────────────────────────────────────────────────┐
│           Layer 3: Supporting Components              │
│  experts/ : 11 个专家身份                              │
│  quality-gates/ : 5 个质量保障组件                     │
│  templates/ : 输出模板                                 │
└──────────────────────────────────────────────────────┘
```

## 3. 三档复杂度的流程图

### L1 轻量级（4 阶段）
```
classify → clarify → execute → review → deliver
```
适用：FAQ、概念解释、单点咨询

### L2 标准级（6 阶段）
```
classify → clarify → resource → plan → execute → review → deliver
```
适用：方案设计、文档撰写、数据分析、行业咨询

### L3 完整级（7 阶段）
```
classify → clarify → resource → plan → design → execute → review → deliver
```
适用：完整项目交付、复杂系统设计

每个流程后都可触发 `refine`（用户验收反馈）形成闭环。

## 4. Skill 的标准结构

每个 skill 是一个独立目录，遵循统一格式：

```
skills/<skill-name>/
├── SKILL.md              # 主文件（前言 + 输入 + 输出 + 步骤 + 质量门）
├── README.md             # 单独使用说明
├── templates/            # 该 skill 专用模板（可选）
└── examples/             # 该 skill 使用示例（可选）
```

每个 SKILL.md 包含：
- **frontmatter**：name / version / triggers / required-quality-gates
- **能做什么** / **不能做什么**
- **输入规范**
- **执行步骤**
- **质量门要求**
- **输出规范**
- **失败处理**
- **单独使用 vs 整体使用的差异**

## 5. Skill 间的数据契约

每个 skill 接收上一个 skill 的输出作为输入。统一用 YAML 结构传递：

```yaml
# Skill 输出标准结构
skill: classify
version: 1.0.0
status: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_INPUT
output:
  # skill 特定的输出字段
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 8
  feasibility: 9
evidence_chain:
  - claim: "..."
    rationale: "..."
    source: "..."
    confidence: "✅"
next_skill: clarify | END
notes: "..."
```

## 6. 质量门机制

每个 skill 输出前必须自评 4 个维度（每维 0-10 分）：

| 维度 | 验证方法 | 通过线 |
|------|---------|--------|
| 完备性 | 对照原问题逐点核查 | ≥ 8 |
| 准确性 | 检查证据链完整性 | ≥ 8 |
| 一致性 | 与前面阶段交叉比对 | ≥ 7 |
| 可行性 | 用预设场景模拟执行 | ≥ 7 |

不达标 → 重做（最多 3 次）→ 切备选方案 → 简化上报。

详细规范见 `quality-gates/four-dimensions.md`。

## 7. 路由规则

### 路由优先级
1. 用户明确指定 skill → 直接调用
2. 用户明确指定专家身份 → 加载身份后从 clarify 开始
3. 用户提问 → 经 classify 自动路由

### 复杂度判定（由 classify skill 完成）
- L1：单一问题、答案明确、无需多步推理 → 4 阶段
- L2：需要分析对比、产出文档/方案、有 1-2 个不确定点 → 6 阶段
- L3：多模块项目、需要完整设计、产出物多 → 7 阶段

判定错误时，用户可在阶段 1 后强制升降级。

## 8. 跨平台适配策略

### 文件引用支持的平台（Kiro / Claude Code）
通过 `#[[file:...]]` 加载完整能力树。

### 单文件平台（ChatGPT / 通义 / 豆包）
仅加载 entry.md 自包含内容（包含核心 9 阶段流程的简化版）。

### 适配文件作用
adapters/<platform>.md 包含：
- 该平台特有的工具调用方式
- 该平台的限制（如不支持文件引用）
- 该平台的最佳实践

## 9. 与 gstack 架构的对比

| 维度 | gstack | UEE |
|------|--------|-----|
| Skill 数量 | 60+（任务粒度） | 9（阶段粒度） |
| 入口 | 每个 skill 独立 | 统一 entry + 单 skill 直用 |
| 领域 | 仅软件工程 | 全行业 |
| 流程 | 无统一流程 | 三档自适应 |
| 用户介入 | 几乎每步 | 仅 4 个关键点 |
| 跨平台 | 主要 Claude Code | 6 个主流平台 |

## 10. 演进策略

- v1.0：本架构（核心 9 个 skill + 11 个专家身份）
- v1.1：根据使用反馈，补充更多专家身份
- v1.2：增加 sub-skill（如 plan 下分 plan-architecture / plan-cost）
- v2.0：可能引入 skill 间的并行执行（如 review 与 execute 并发）

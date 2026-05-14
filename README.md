# Universal Expert Engine (UEE)

> 全能行业专家引擎 v1.0.0
> 用户只需要：提问 → 完善条件 → 确认方案 → 拿到结果。

## 核心定位

UEE 是一个让 AI 自主解决任何领域问题的工作流系统。AI 自动判断问题领域、复杂度，加载对应专家身份，按标准流程闭环交付，全程仅在 4 个关键节点请求用户介入。

## 三档复杂度

| 档位 | 适用 | 阶段数 | 时长估计 |
|------|------|--------|---------|
| L1 轻量 | FAQ、单点问答、概念解释 | 4 阶段 | < 2 小时 |
| L2 标准 | 方案设计、文档撰写、行业咨询 | 6 阶段 | 半天-3 天 |
| L3 完整 | 项目交付、复杂系统设计 | 7 阶段 | 1 周以上 |

## 9 个独立可用 Skill

每个 skill 既可单独调用，也能整体编排：

1. **classify** — 问题分类与专家路由
2. **clarify** — 问题澄清与理解确认
3. **resource** — 资源分析与约束识别
4. **plan** — 方案设计与对比
5. **design** — 详细设计（仅 L3）
6. **execute** — 执行产出
7. **review** — 自检与质量门
8. **deliver** — 交付包装
9. **refine** — 反馈优化

## 用户介入仅 4 处

| 节点 | 时机 | 用户做什么 |
|------|------|-----------|
| 🔵 P1 | clarify 完成后 | 确认理解 |
| 🔵 P2 | plan 完成后 | 选方案 |
| 🔴 P3 | 遇阻塞 | 二选一/多选一 |
| 🟢 P4 | deliver 完成后 | 验收 |

## 使用方式

### 方式 1：在 Kiro 中（最简单）
通过 steering 自动加载，直接提问即可。

### 方式 2：在其他平台
把 `entry.md` 内容粘贴到对应平台的系统提示词。
- Cursor: `.cursorrules` 或 Settings → Rules for AI
- Claude Code: 项目根目录 `CLAUDE.md`
- Windsurf: `.windsurfrules`
- ChatGPT/GPTs: Instructions
- Claude Projects: Project Instructions

### 方式 3：单 Skill 调用
直接告诉 AI："使用 review skill 检查这个文档"，会跳过流程编排只跑那一个 skill。

## 项目结构

```
universal-expert-engine/
├── entry.md              # 总入口（自包含路由 + 平台检测）
├── ETHOS.md              # 行为准则（不变量）
├── ARCHITECTURE.md       # 架构设计
├── skills/               # 9 个独立 skill
├── orchestrator/         # 流程编排
├── experts/              # 专家身份库
├── quality-gates/        # 质量保障组件
├── adapters/             # 平台适配器
├── templates/            # 输出模板
└── examples/             # 完整示例
```

## 设计原则

1. **复杂度自适应**：AI 自动判断 L1/L2/L3，不让用户操心
2. **专家身份动态**：根据领域加载对应专家，不固定角色
3. **四维质量门**：完备性/准确性/一致性/可行性，每阶段强制通过
4. **证据链可追溯**：每个论断有论据 → 来源 → 可信度三元组
5. **失败三层降级**：重试 → 备选 → 简化上报

## 与 gstack / universal-problem-solver 的关系

- 借鉴 gstack 的 **Skill 化架构**（独立子目录，可单独使用）
- 继承 universal-problem-solver 的 **跨平台单文件入口**
- 整合现有 7 阶段交付流程的 **质量保障与角色划分**
- 新增 **复杂度自适应** 和 **动态专家身份**

## 版本

v1.0.0 — 初始发布

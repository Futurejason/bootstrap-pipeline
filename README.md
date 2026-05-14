# Universal Expert Engine (UEE)

> 全能行业专家引擎 v1.0.0
> 用户只需要：提问 → 完善条件 → 确认方案 → 拿到结果。

## 快速开始（30 秒）

```bash
# 1. 克隆仓库
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee

# 2. 一键安装（自动检测平台）
./setup.sh
```

完整安装指南见 [INSTALL.md](INSTALL.md)，按平台分别说明：
- [Kiro](adapters/kiro.md) | [Claude Code](adapters/claude-code.md) | [Cursor](adapters/cursor.md)
- [Windsurf](adapters/windsurf.md) | [ChatGPT](adapters/chatgpt.md) | [Claude](adapters/claude.md)

## 这是什么

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

## 11 个动态专家身份

软件工程师 / 解决方案架构师 / 产品经理 / 内容创作者 / 商业咨询 / 数据分析师 / 法律顾问 / 医疗参考 / 营销策略师 / 教育工作者 / 通用兜底

## 项目结构

```
uee/
├── INSTALL.md            # 全平台安装指南
├── setup.sh              # 一键安装脚本
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

1. **复杂度自适应**：AI 自动判断 L1/L2/L3
2. **专家身份动态**：根据领域加载对应专家
3. **四维质量门**：完备性/准确性/一致性/可行性，每阶段强制通过
4. **证据链可追溯**：每个论断有论据 → 来源 → 可信度三元组
5. **失败三层降级**：重试 → 备选 → 简化上报

## 验证 UEE 是否生效

提问任意问题，AI 应该：
1. 不直接回答，而是先输出 `[classify] domain=... complexity=...`
2. 关键论断带 `【论断】【论据】【来源】【可信度】` 三元组
3. 在 P1/P2/P4 节点暂停等用户

如果 AI 直接回答没有上述结构 → 检查配置文件路径，详见 [INSTALL.md 的"通用问题"](INSTALL.md#通用问题)。

## 升级

```bash
cd /path/to/uee
git pull origin main
```

如果用了 Cursor / Windsurf / Claude Code，需要重新生成配置文件：

```bash
cp entry.md .cursorrules    # 或 .windsurfrules / CLAUDE.md
```

Kiro 用户的 steering 文件不需要改（用的相对路径）。
ChatGPT / Claude Projects 需手动重新粘贴 Instructions。

## 版本

v1.0.0 — 初始发布

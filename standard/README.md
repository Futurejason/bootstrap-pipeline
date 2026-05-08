# AI Full-Stack Delivery Standard

## 这是什么

一套**平台无关的 AI 智能体行为标准**，定义了 AI 从需求分析到生产部署的完整交付流程，以及每个阶段的角色、职责和验收要求。

任何 AI 工具通过引入此标准，即可获得完整的七阶段交付能力。

## 文件结构

```
standard/
├── agent-standard.json     # 机器可读核心标准（AI 工具直接解析）
├── agent-standard.md       # 人类可读完整规范（真相来源）
├── README.md               # 本文件
└── adapters/               # 各平台适配器（薄层，引用核心标准）
    ├── CLAUDE.md           # Claude Code
    ├── .cursorrules        # Cursor
    └── copilot-instructions.md  # GitHub Copilot
```

## 如何引入

### 方式一：直接解析 JSON（推荐用于 AI 工具集成）

```javascript
const standard = await fetch('https://raw.githubusercontent.com/your-repo/standard/agent-standard.json')
  .then(r => r.json())
// standard.invariants — 铁律列表
// standard.phases — 七阶段定义
// standard.roles — 角色定义
```

### 方式二：使用平台适配器

| 平台 | 操作 |
|------|------|
| **Cursor** | 复制 `adapters/.cursorrules` 到项目根目录 |
| **Claude Code** | 复制 `adapters/CLAUDE.md` 到项目根目录 |
| **GitHub Copilot** | 复制 `adapters/copilot-instructions.md` 到 `.github/` |
| **Kiro** | 复制 `agent-standard.md` 到 `.kiro/steering/` |
| **其他工具** | 将 `agent-standard.md` 内容粘贴到 System Prompt |

### 方式三：作为项目依赖引入

```bash
# 下载标准文件到项目
curl -O https://raw.githubusercontent.com/your-repo/standard/agent-standard.json
curl -O https://raw.githubusercontent.com/your-repo/standard/agent-standard.md
```

## 核心内容

### 七阶段工作流

```
Phase 1 [解决方案专家] 理解问题 → 方案方向 + 资源清单
Phase 2 [解决方案专家] 分析资源 → 循环澄清直到无歧义
Phase 3 [产品经理]     整理 PRD → 功能需求 + 验收标准
Phase 4 [架构师]       技术设计 → 架构 + 接口 + 部署方案
Phase 5 [全栈工程师]   逐模块实现 → 代码与文档一致
Phase 6 [QA 工程师]    端到端测试 → 覆盖所有入口 + 异常场景
Phase 7 [DevOps]       部署上线 → 验证生产 → 自行排查问题
```

### 七条铁律

1. 每阶段完成后等待用户确认
2. 用户反馈问题时自行排查，不转移给用户
3. 验收测试覆盖所有功能入口 + 异常场景
4. 部署前读取所有配置文件，识别潜在问题
5. 配置文件已存在时验证内容，不跳过
6. 文档、代码、配置三者保持一致
7. 技术方案注明来源

## 版本

v1.0.0 — 初始版本

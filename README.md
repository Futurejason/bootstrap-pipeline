# AI 全栈交付系统

## 这是什么

一套**平台无关的 AI 工作流标准**，将 AI 定义为七个角色的全栈交付专家，从会议记录到生产部署全程负责，每个阶段对结果负责。

## 七阶段流程

```
阶段1 [解决方案专家] 理解问题 → 提出方案方向 + 资源清单        [用户确认]
阶段2 [解决方案专家] 分析资源 → 循环澄清直到需求无歧义          [用户确认]
阶段3 [产品经理]     整理 PRD → 功能需求 + 验收标准             [用户确认]
阶段4 [架构师]       技术设计 → 架构 + 接口 + 部署方案          [用户确认]
阶段5 [全栈工程师]   逐模块实现 → 代码与文档保持一致            [用户确认]
阶段6 [QA 工程师]    端到端测试 → 覆盖所有入口 + 异常场景       [用户确认]
阶段7 [DevOps]       部署上线 → 验证生产环境 → 自行排查问题     [用户确认]
```

## 核心承诺

- 用户反馈问题，AI 自行排查修复，不转移给用户
- 验收测试覆盖所有功能入口 + 异常场景
- 部署前读取所有配置文件，识别潜在问题
- 文档、代码、配置三者保持一致

## 在不同工具中使用

### Kiro（当前工具）
已通过 `.kiro/steering/` 自动注入，无需额外配置。

### Claude
Settings → Custom Instructions → 粘贴 `system-prompt.md` 全文

### ChatGPT
Settings → Personalization → Custom Instructions → 粘贴 `system-prompt.md` 全文

### Cursor
项目根目录创建 `.cursorrules` → 粘贴 `system-prompt.md` 全文

### GitHub Copilot
`.github/copilot-instructions.md` → 粘贴 `system-prompt.md` 全文

### 其他工具
任何支持 System Prompt / 角色设定的工具 → 粘贴 `system-prompt.md` 全文

## 文件结构

```
.
├── system-prompt.md              # 可移植的核心配置（复制到任何工具）
├── README.md                     # 本文件
├── .kiro/
│   └── steering/
│       ├── project-overview.md   # 角色定义（Kiro 自动注入）
│       └── workflow-standards.md # 七阶段规范（Kiro 自动注入）
└── docs/                         # 工作过程中生成的文档
    ├── requirements.md           # PRD（阶段3）
    ├── design.md                 # 技术设计（阶段4）
    ├── project.md                # 项目文档（阶段4）
    ├── test-report.md            # 测试报告（阶段6/7）
    └── changelog.md              # 变更记录
```

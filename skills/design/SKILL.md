---
name: design
version: 1.0.0
description: 详细设计。为方案做架构图、数据模型、接口定义。仅 L3 复杂度使用。
triggers:
  - 画架构图
  - 详细设计
  - 接口定义
required-quality-gates: [completeness, accuracy, consistency, feasibility]
---

# Skill: design — 详细设计

## 能做什么

- 为已确认的方案做详细技术/业务设计
- 输出架构图、模块划分、接口定义、数据模型、部署方案
- 标注每个选型的依据和来源

## 不能做什么

- 不重新规划方案（属于 plan skill）
- 不写代码（属于 execute skill）
- 不部署（属于 execute / 用户配合）

## 输入规范

```yaml
input:
  plan_output: object  # 用户已确认的方案
  resource_output: object
  expert: string
```

## 执行步骤

### Step 1: 整体架构图

用 Mermaid 或 ASCII 画图，必须包含：
- 系统边界（输入/输出）
- 主要模块
- 数据流向
- 外部依赖

软件项目 → 系统架构图
商业方案 → 业务流程图 + 组织架构图
内容项目 → 内容结构图

### Step 2: 模块/组件划分

每个模块说明：
- 职责
- 输入/输出
- 依赖关系
- 技术/资源选型 + 依据

技术选型必须附证据：
```
【选型】FastAPI
【论据】异步性能、自动 OpenAPI、类型安全
【来源】FastAPI 官方文档 — https://fastapi.tiangolo.com/
【可信度】✅
```

### Step 3: 接口/边界定义

软件项目：
- API 路径、方法、参数、响应、错误码
- 数据库表 schema

商业项目：
- 关键业务流程的输入输出
- 部门/角色之间的协作接口

### Step 4: 数据模型

ER 图或表格描述：
- 实体名
- 字段名 / 类型 / 约束
- 实体间关系

### Step 5: 部署/落地方案

软件项目：
- 部署拓扑（开发/测试/生产）
- 容量规划
- 监控告警点

商业项目：
- 实施阶段（里程碑）
- 资源调配（人/钱/物）
- 关键节点

### Step 6: 风险与应对

| 风险 | 影响 | 概率 | 应对 |
|------|------|------|------|
| 风险 1 | 高 | 中 | ... |

### Step 7: 部署前检查清单（适用软件项目）

```
- [ ] 配置文件已审查
- [ ] IP 白名单/权限
- [ ] 端口占用确认
- [ ] 依赖版本兼容性
- [ ] 备份策略
- [ ] 回滚方案
```

## 输出规范

```yaml
skill: design
version: 1.0.0
status: DONE
output:
  architecture_diagram: "mermaid 或 ascii"
  modules:
    - name: "..."
      responsibility: "..."
      io: "..."
      dependencies: [...]
      tech_choice:
        name: "..."
        rationale: "..."
        source: "..."
        confidence: "✅"
  interfaces: [...]
  data_model: [...]
  deployment_plan: "..."
  risks: [...]
  pre_deploy_checklist: [...]
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 9
  feasibility: 9
next_skill: execute
```

## 质量门要求

- **完备性**：架构/模块/接口/数据/部署/风险都覆盖 → ≥ 9
- **准确性**：每个选型有来源 → ≥ 9
- **一致性**：与 plan 输出一致 → ≥ 9
- **可行性**：部署清单可执行 → ≥ 9

## 失败处理

### 设计冲突（plan 中的多个方案点不能同时实现）
→ 暴露冲突 → 上报让用户决策

### 部署清单发现致命问题（如端口冲突）
→ 提交 P3 阻塞决策

## 单独使用模式

用户说"帮我画这个系统的架构图" → 仅输出架构相关内容。

## 整体使用模式

仅 L3 流程使用，输出传给 execute。

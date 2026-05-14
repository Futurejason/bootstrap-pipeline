# L3 完整级流程

## 适用场景

- 完整项目交付、复杂系统设计
- 多模块、需要详细设计
- 复杂度评分 6+

## 流程

```
classify → clarify → resource → plan → design → execute → review → deliver
```

7 个阶段（不含 classify）。

## 用户介入点

- 🔵 P1：clarify 完成后
- 🔵 P2：plan 完成后
- 🔵 P2'：design 完成后（L3 特有的设计确认，可选）
- 🔴 P3：任意阶段阻塞时
- 🟢 P4：deliver 完成后

## 时间预估

- 中等项目：3-7 天
- 复杂项目：1-4 周
- 超大项目：1 月+

## 关键流程节点

### design 阶段（L3 特有）
- 必须输出架构图
- 必须有部署前检查清单
- 关键技术选型必须有证据链

### execute 阶段
- 按子模块逐步实现
- 每完成一个模块汇报进度
- 遇问题立即暂停

### review 阶段
- 评分线更高（默认 ≥ 8）
- 包含部署清单可执行性检查

## 示例：搭建多租户 SaaS 系统

```
用户：帮我设计并实现一个多租户 SaaS 系统

[classify] domain=software, complexity=L3, expert=solution-architect

[clarify]
  - 复述：多租户 SaaS 系统设计与实现
  - P1：租户隔离级别？（共享/独立 schema/独立 DB）
  - P1：预期租户规模？

用户回复...

[resource]
  - 提取需求：用户管理、计费、数据隔离
  - 约束：技术栈 Python/PostgreSQL

[plan]
  - 方案 A：共享 schema + 字段隔离
  - 方案 B：独立 schema/租户
  - 方案 C：独立 DB/租户
  - P2 用户选 B

[design]
  - 系统架构图（API Gateway / Auth / Tenant Service / Billing）
  - 数据模型（Tenant / User / Subscription）
  - 接口定义
  - 部署拓扑
  - 部署前检查清单
  - 风险评估

[execute]
  - 模块 1：Auth Service（OAuth + JWT）
  - 模块 2：Tenant Service（schema 创建/路由）
  - 模块 3：Billing Service（Stripe 集成）
  - 模块 4：监控告警
  - 每个模块带测试

[review] 4 维评分

[deliver]
  - 完整代码 + 部署文档 + 测试报告
  - 🟢 P4 验收
```

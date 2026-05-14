# L3 完整示例：复杂软件项目

## 用户提问

> "帮我设计并实现一个支持多租户的 SaaS 数据分析平台，包含用户管理、计费、数据隔离"

## AI 执行过程概要

### Skill 1: classify
```yaml
domain: software-engineering
complexity: L3
complexity_score: 8
expert: solution-architect
recommended_flow: L3-full
estimated_time: 2-3 weeks
```

### Skill 2: clarify

P1 决策简报：

```
🔵 D1 — 多租户隔离级别

情境：多租户 SaaS 的数据隔离方案直接决定架构复杂度和成本

通俗解释：3 种隔离方式各有优劣：
- 共享 schema + 字段隔离：所有租户数据混在一张表里，靠 tenant_id 区分
- 独立 schema：每个租户一个数据库 schema，物理隔离更强
- 独立 DB：每个租户一个数据库，最严格的隔离

不清楚的地方：你需要的隔离级别？
影响范围：数据库设计、查询性能、运维成本

选项 A：共享 schema（推荐 MVP）
  ✅ 开发简单、横向扩展容易
  ✅ 运维成本低（一套 DB 服务所有租户）
  ❌ 数据混合存储，合规要求高时不够

选项 B：独立 schema/租户
  ✅ 物理隔离更强，合规更友好
  ✅ 单租户性能问题不影响其他
  ❌ schema 数量增加管理成本，跨租户分析复杂

选项 C：独立 DB/租户
  ✅ 最强隔离，可单独备份/迁移
  ❌ 100+ 租户时运维爆炸

推荐：方案 A（MVP 起步），保留迁移到 B 的可能
```

用户回复："选 A，未来支持迁移到 B"

P1 决策简报 D2：

```
🔵 D2 — 计费模型

情境：SaaS 计费会决定订阅、用量统计、Stripe 集成的设计

不清楚的地方：计费模式是哪种？
- 订阅制（月/年付固定费用）
- 用量制（按 API 调用 / 数据量）
- 混合（订阅 + 超额按用量）

推荐：混合（订阅基础包 + 超额按用量），最常见的 SaaS 模式
```

用户回复："混合"

### Skill 3: resource

提取所有约束：
- 技术栈：Python 后端（FastAPI + PostgreSQL + Redis）
- 隔离：共享 schema + 未来可迁移
- 计费：订阅 + 超额用量
- 支付：Stripe
- 部署：Docker + Kubernetes（用户后续提供）

### Skill 4: plan

3 个候选方案，用户选 B（中等复杂度，工程化好）：

```
| 维度 | A：单体应用 | B：模块化单体 | C：微服务 |
|------|-----------|---------------|----------|
| 开发周期 | 2 周 | 3 周 | 6 周 |
| 部署复杂度 | 低 | 低 | 高 |
| 性能瓶颈 | 早 | 中等 | 晚 |
| 运维成本 | 低 | 低 | 高 |
| 适合阶段 | < 100 租户 | 100-1000 | 1000+ |
推荐：B
```

### Skill 5: design

输出完整技术设计：

```markdown
# 多租户 SaaS 数据分析平台 — 技术设计

## 1. 系统架构

[Mermaid 架构图]
┌─────────────┐
│ Frontend    │ Next.js
└──────┬──────┘
       │
┌──────▼──────────────────────────┐
│ API Gateway (FastAPI)            │
│ - JWT 认证                        │
│ - Tenant 路由                    │
└──┬──────────┬─────────┬──────────┘
   │          │         │
┌──▼──────┐ ┌▼───────┐ ┌▼─────────┐
│ Auth    │ │ Data   │ │ Billing  │
│ Service │ │ Service│ │ Service  │
└─────────┘ └────────┘ └──────────┘
   │          │         │
   └──────────┼─────────┘
              ▼
        PostgreSQL
        (tenant_id 隔离)

## 2. 模块划分

### 2.1 Auth Service
- 职责：用户注册/登录/JWT 签发
- 技术：FastAPI + python-jose
- 依据：FastAPI 安全文档 https://fastapi.tiangolo.com/tutorial/security/
- 可信度：✅

### 2.2 Tenant Service
[详细]

### 2.3 Data Service
[详细]

### 2.4 Billing Service
- 职责：订阅管理 + Stripe 集成 + 用量计费
- 技术：Stripe Python SDK
- 依据：Stripe Subscriptions API https://stripe.com/docs/billing/subscriptions/overview
- 可信度：✅

## 3. 数据模型

```sql
-- tenants 表
CREATE TABLE tenants (...)

-- users 表（带 tenant_id）
CREATE TABLE users (...)

-- 行级安全（RLS）
CREATE POLICY tenant_isolation ON ...
```

## 4. 接口定义

[OpenAPI 摘要]

## 5. 部署拓扑

[K8s 拓扑图]

## 6. 部署前检查清单

- [ ] 数据库 RLS 策略测试
- [ ] Stripe webhook 签名验证
- [ ] JWT 密钥管理
- [ ] 租户数据迁移脚本
- [ ] 监控告警接入
- [ ] 备份策略
```

### Skill 6: execute

按 8 个模块逐步执行：

1. 项目初始化（FastAPI + uv + 目录结构）
2. 数据模型 + RLS
3. Auth Service
4. Tenant Service（含路由中间件）
5. Data Service（数据上传 / 查询）
6. Billing Service（Stripe 集成）
7. 单元测试 + 集成测试
8. Docker 化 + 部署文档

每个模块完成后输出进度报告：

```
## 模块 3 完成：Auth Service

### 完成内容
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/refresh
- JWT 签发与验证中间件

### 与设计文档对应
- 完全一致

### 验证结果
| 测试 | 状态 |
|------|------|
| 注册成功 | ✅ |
| 登录成功 | ✅ |
| token 过期 | ✅ |
| 错误密码 | ✅ |

✅ 进入下一模块
```

### Skill 7: review

每个模块都跑 review，最后整体跑一次：

```yaml
status: PASSED
scores:
  completeness: 9
  accuracy: 9
  consistency: 9
  feasibility: 9
adversarial_findings:
  - 安全视角：API rate limiting 未实现
  - 用户视角：错误信息可能泄露内部细节
  - 维护者视角：缺少 OpenTelemetry 追踪
improvements:
  p0:
    - 补充 rate limiting（slowapi 库）
    - 错误信息脱敏
  p1:
    - 后续添加 OTel
```

execute 补充 P0 → review 再次 PASSED。

### Skill 8: deliver

输出完整项目（保存为 `multi-tenant-saas/` 目录）：

```
multi-tenant-saas/
├── README.md
├── ARCHITECTURE.md
├── docs/
│   ├── requirements.md
│   ├── design.md
│   ├── deployment.md
│   ├── test-report.md
│   └── api-reference.md
├── backend/
│   ├── pyproject.toml
│   ├── Dockerfile
│   └── src/
│       ├── auth/
│       ├── tenants/
│       ├── data/
│       ├── billing/
│       └── core/
├── tests/
└── docker-compose.yml
```

## 用户介入次数

5 次：
- P1 D1（隔离级别）
- P1 D2（计费模型）
- P2（方案选型）
- P3（中途 Stripe webhook 发现一个不确定）
- P4（最终验收）

## 总耗时

约 5-10 天（视模块数量和测试覆盖度）。

## 关键学习点

- L3 必跑 design 阶段
- 部署前检查清单不可省
- 多模块执行 → 每模块独立报告
- 整体 review 之外，每模块也独立 review
- 安全/性能等 P0 改进必须修后才能 deliver

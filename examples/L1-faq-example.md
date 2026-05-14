# L1 完整示例：技术问答

## 用户提问

> "FastAPI 和 Flask 哪个更适合做 AI 应用后端？"

## AI 执行过程

### Skill 1: classify

```yaml
status: DONE
output:
  domain: software-engineering
  complexity: L1
  complexity_score: 1
  expert: software-engineer
  recommended_flow: L1-light
  estimated_time: 5min
  reasoning: |
    - 单一对比问题
    - 答案明确（不需要多步推理或对比）
    - 无产出物多形态
    评分 1，归为 L1。
quality_score:
  completeness: 9
  accuracy: 10
  consistency: 10
  feasibility: 10
next_skill: clarify
```

输出给用户：
```
✅ classify 完成
- 问题领域：软件工程
- 复杂度：L1（轻量）
- 推荐专家：Software Engineer
- 预估时间：5 分钟
➡️ 即将进入：clarify
```

### Skill 2: clarify

```yaml
status: DONE  # 无阻塞性不确定
output:
  understanding: "用户想对比 FastAPI 和 Flask 在 AI 应用后端场景的适配性"
  goal: "技术选型建议"
  output_form: "对比 + 推荐"
  constraints:
    - "AI 应用后端场景"
  blocking_uncertainties: []
  non_blocking_defaults:
    - assumption: "AI 应用 = 调用 LLM API（如 Claude/OpenAI）的服务"
      default: "假设是这种"
      reason: "最常见场景"
quality_score:
  completeness: 9
  accuracy: 10
  consistency: 10
  feasibility: 10
next_skill: execute  # L1 跳过 resource 和 plan
```

### Skill 3: execute

直接产出对比答案：

```markdown
# FastAPI vs Flask（AI 应用后端场景）

## 推荐：FastAPI

## 主要差异

### 1. 异步支持

【论断】FastAPI 原生支持 async/await，Flask 需要扩展（如 Quart）才能异步
【论据】LLM API 调用是 IO 密集型，异步性能差异显著
【来源】FastAPI 官方文档 — https://fastapi.tiangolo.com/async/
【可信度】✅

实际影响：处理 100 个并发 LLM 调用时，FastAPI 通过事件循环高效复用单进程，Flask 需要更多 worker 进程。

### 2. 类型安全 + 自动校验

【论断】FastAPI 用 Pydantic 自动校验请求/响应，Flask 需手动写校验逻辑
【论据】LLM 应用对结构化输入输出要求高
【来源】Pydantic 文档 — https://docs.pydantic.dev/
【可信度】✅

实际影响：Prompt 模板的参数校验、Tool Use 的 schema 定义、流式响应的类型推断，FastAPI 都更省事。

### 3. OpenAPI 文档自动生成

【论断】FastAPI 自动生成 Swagger UI / ReDoc，Flask 需要 Flasgger 等额外配置
【论据】AI 服务通常需要给前端/客户端提供 API 文档
【来源】FastAPI Docs — https://fastapi.tiangolo.com/features/
【可信度】✅

### 4. 流式响应（Streaming）

【论断】FastAPI 用 StreamingResponse 处理 SSE 更简洁
【论据】LLM 流式输出需要 SSE 或 WebSocket
【来源】FastAPI Streaming — https://fastapi.tiangolo.com/advanced/custom-response/#streamingresponse
【可信度】✅

## Flask 的优势场景

【论断】简单 CRUD、需要复用大量 Flask 生态扩展时，Flask 仍合适
【论据】Flask 生态（如 Flask-Login、Flask-SQLAlchemy）成熟
【来源】Flask 官方扩展列表 — https://flask.palletsprojects.com/extensions/
【可信度】✅

## 性能对比

【论断】FastAPI 在 IO 密集场景吞吐量是 Flask 的 2-3 倍
【论据】社区基准测试（TechEmpower benchmarks）
【来源】https://www.techempower.com/benchmarks/
【可信度】🔶（基准测试与实际场景有差异）

## 推荐选 FastAPI 的场景
- 调用 LLM API 的服务
- 需要流式输出
- 多并发请求
- 需要严格类型/输入输出 schema

## 推荐选 Flask 的场景
- 简单 CRUD 服务
- 团队已熟悉 Flask 且无 LLM 强需求
- 严重依赖某个 Flask 专属扩展
```

```yaml
status: DONE
quality_score:
  completeness: 9
  accuracy: 9
  consistency: 10
  feasibility: 10
next_skill: review
```

### Skill 4: review

```yaml
status: PASSED
output:
  scores:
    completeness: 9
    accuracy: 9
    consistency: 10
    feasibility: 10
  adversarial_findings:
    - 用户视角：没说"如果团队完全不懂 Python 异步怎么办"
    - 维护者视角：版本号未指定（FastAPI/Flask 哪个版本）
    - 极端场景：超大流量是否还是 FastAPI 优？
  improvements:
    p2:
      - 补充："如果团队不熟异步，需评估学习成本"
quality_score:
  completeness: 10
  accuracy: 10
  consistency: 10
  feasibility: 10
decision: PASS
next_skill: deliver
```

### Skill 5: deliver

```markdown
# FastAPI vs Flask（AI 应用后端） — 解决方案

## 摘要

| 项 | 内容 |
|----|------|
| 原始问题 | FastAPI 和 Flask 哪个更适合做 AI 应用后端？ |
| 采用方案 | 直接对比答案 |
| 关键决策 | 推荐 FastAPI |
| 整体可信度 | ✅ 确定 |
| 完成时间 | 4 分钟 |
| 专家身份 | Software Engineer |

## 主体产出

[上面 execute 的完整内容]

## 决策记录

| # | 决策点 | 选项 | 选择 | 理由 |
|---|-------|------|------|------|
| 1 | 复杂度 | L1/L2/L3 | L1 | 单一对比问题 |
| 2 | 推荐 | FastAPI/Flask | FastAPI | 异步、类型、文档自动 |

## 质量报告

| 维度 | 分数 | 状态 |
|------|------|------|
| 完备性 | 10/10 | ✅ |
| 准确性 | 10/10 | ✅ |
| 一致性 | 10/10 | ✅ |
| 可行性 | 10/10 | ✅ |

### 已知局限
- 性能数据基于通用基准测试，实际差异因场景不同
- 未涉及 Litestar、Sanic 等新兴 Python 异步框架（如有需要可补充）

## 证据链汇总

| # | 论断 | 来源 | 可信度 |
|---|------|------|--------|
| 1 | FastAPI 原生异步 | FastAPI Docs | ✅ |
| 2 | Pydantic 类型校验 | Pydantic Docs | ✅ |
| 3 | 性能 2-3x | TechEmpower | 🔶 |

## 后续建议

### 立即可做
- 用 `uv` 初始化 FastAPI 项目：`uv init my-ai-backend`
- 安装：`uv add fastapi uvicorn anthropic`

### 需要验证的假设
- 假设了"AI 应用 = LLM 调用"。如果是 ML 模型推理（如 PyTorch），可能需要考虑 Ray Serve / TorchServe

### 可选优化
- 如团队不熟异步，可先看 Anthropic/OpenAI Python SDK 的同步 vs 异步示例

---

🟢 P4 — 请验收

我已完成对比分析。请检查：
- 通过 → 完成
- 修改意见 → 进入 refine
- 整体重做 → 回退到 plan
```

## 用户介入次数

仅 1 次：P4 验收。

## 总耗时

约 4-5 分钟。

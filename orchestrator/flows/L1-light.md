# L1 轻量级流程

## 适用场景

- FAQ、概念解释、单点问答
- 答案明确，无需多步推理
- 复杂度评分 0-2

## 流程

```
classify → clarify → execute → review → deliver
```

4 个阶段（不含 classify 的路由本身）。

## 用户介入点

- 🔵 P1：clarify 完成后（仅当有阻塞性不确定）
- 🟢 P4：deliver 完成后

通常 L1 没有 P2/P3，因为不做方案对比、很少阻塞。

## 时间预估

- 简单技术问答：2-5 分钟
- 概念解释：5-10 分钟
- 简单咨询：10-30 分钟

## 跳过 P1 的判定

如果 clarify 中无阻塞性不确定，自动跳过 P1，直接进 execute。

## 示例：FastAPI vs Flask

```
用户：FastAPI 和 Flask 哪个更快？

[classify] domain=software, complexity=L1, expert=software-engineer
[clarify] 无阻塞性不确定 → 跳过 P1
[execute]
  - 性能对比数据（带证据链）
  - 适用场景对比
  - 推荐建议
[review] 4 维评分通过
[deliver] 输出最终回答 → P4 验收
```

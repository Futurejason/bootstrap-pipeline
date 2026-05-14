# Orchestrator — 流程编排器

## 职责

根据 classify 输出的复杂度，编排 skill 执行顺序，传递数据契约，管理用户介入点。

## 执行算法

```
1. 收到用户消息
2. 跑 classify → 得到 domain / complexity / expert / flow
3. 加载对应专家身份（experts/<expert>.md）
4. 按 flow 加载流程文件（flows/L1|L2|L3-*.md）
5. 按流程顺序调用 skill：
   for skill in flow.skills:
     output = run(skill, input=previous_output)
     if output.status == NEEDS_INPUT:
        触发对应用户介入点（P1/P2/P3）
        wait for user response
     if output.status == BLOCKED:
        进入失败处理协议
6. 流程完成 → 触发 P4 验收
7. 用户反馈 → refine 循环 → 直到验收通过
```

## 数据传递契约

每个 skill 输出 YAML，包含：
- `status`：DONE / DONE_WITH_CONCERNS / NEEDS_INPUT / BLOCKED
- `output`：skill 特定输出
- `quality_score`：4 维评分
- `evidence_chain`：证据链
- `next_skill`：下一个 skill（可能根据条件分支）

orchestrator 负责把 `output` 传给下一个 skill 的 `input`。

## 用户介入点的触发逻辑

| 介入点 | 触发条件 | 处理方式 |
|--------|---------|---------|
| 🔵 P1 | clarify.status == NEEDS_INPUT | 提交决策简报，等待用户回复 |
| 🔵 P2 | plan.status == AWAITING_USER_CHOICE | 提交方案对比，等待用户选择 |
| 🔴 P3 | 任意 skill.status == BLOCKED | 暴露阻塞点，等待用户决策 |
| 🟢 P4 | deliver.status == AWAITING_ACCEPTANCE | 提交验收，等待用户确认 |

## 失败处理协议

### Skill 单次失败（status == DONE_WITH_CONCERNS）
- 评分某维度 < 通过线但差距 ≤ 2
- → 继续下一 skill，但在 deliver 中标注担忧

### Skill 失败重做（review.decision == RETRY）
- review 评分不通过
- → 回到上一个 skill 重做（execute 或 plan）
- 最多 3 次

### 重做耗尽
- → review.decision == DOWNGRADE
- → 简化交付，明确告知哪些没做

### Skill 卡死（status == BLOCKED）
- → 触发 P3 阻塞决策
- → 用户决策后恢复或终止

## 状态机视图

```
[START]
  ↓
[classify]
  ↓
[load expert]
  ↓
[clarify] ─→ NEEDS_INPUT? → [P1 用户介入] → 回到 clarify
  ↓ DONE
[resource]  (L2/L3 only)
  ↓ DONE
[plan] ─→ [P2 用户介入] → 选定方案
  ↓
[design]    (L3 only)
  ↓ DONE
[execute]
  ↓ DONE
[review] ─→ FAILED? → 回到 execute（最多 3 次）
  ↓ PASSED
[deliver] ─→ [P4 用户介入]
  ↓ accepted    ↓ feedback
[END]         [refine] → 回到 deliver
```

## 单 Skill 直用模式

用户消息匹配单 skill 触发词（见每个 SKILL.md 的 triggers）→ 跳过 orchestrator，直接调用该 skill。

## 复杂度升降级

用户在 clarify 完成后可强制升降级：
- "这个比想象的复杂，按 L3 走" → 切换到 L3-full
- "简单点就行，L1 处理" → 切换到 L1-light

升降级后从当前阶段开始按新流程走。

## 错误恢复

整个流程任意阶段被用户打断（"等等，我要改 X"）：
- 保留当前所有产出
- 接受用户输入
- 询问从哪里继续：
  - "回到 clarify" → 回到第 2 阶段
  - "回到 plan" → 回到方案设计
  - "继续" → 从打断处继续

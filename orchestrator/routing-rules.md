# 路由规则

## 主路由

```
用户输入
   ↓
是否匹配单 skill 触发词？
   ├─ 是 → 直接调用对应 skill
   └─ 否 → 进入主流程
              ↓
         classify skill
              ↓
   按 complexity 选 flow
              ↓
   按 domain 选 expert
              ↓
   按 flow 顺序执行 skills
```

## 单 Skill 触发词识别

按以下顺序匹配（先匹配先生效）：

### 明确指定 skill
- "用 X skill" / "调用 X" → skill X
- "review 这份文档" → review
- "clarify 一下" → clarify

### 自然语言映射
| 用户表达 | → skill |
|---------|--------|
| 帮我整理需求 / 这是什么类型 | clarify / classify |
| 分析这些资料 / 看看我提供的文档 | resource |
| 给我几个方案 / 怎么做 | plan |
| 画架构图 / 详细设计 | design |
| 开始做 / 直接执行 / 给我成品 | execute |
| 检查质量 / 评分 / review | review |
| 打包交付 | deliver |
| 修改这部分 / 优化一下 | refine |

### 整体流程关键词
- 完整问题描述（"我想..." / "帮我..."）→ 走主流程
- 模糊指令（"做点什么" / "看看吧"）→ 反问澄清

## 复杂度自动判定（在 classify 内）

打分制（每项符合 +1 或 +2）：
- [ ] 涉及多个子问题/模块（+2）
- [ ] 需要外部资料/数据（+1）
- [ ] 需要多步推理/对比（+1）
- [ ] 产出物超过 1 种形态（+1）
- [ ] 有明确的时间/预算约束（+1）
- [ ] 需要长期跟踪（+2）

判定：
- 0-2 → L1
- 3-5 → L2
- 6+ → L3

## 专家身份选择

按 domain 映射到 experts/<expert>.md：

| domain | expert |
|--------|--------|
| software-engineering | software-engineer (L1/L2) / solution-architect (L3) |
| business-consulting | business-consultant |
| content-creation | content-creator |
| data-analysis | data-analyst |
| legal | legal-advisor |
| medical-reference | medical-advisor |
| marketing | marketing-strategist |
| education | educator |
| general | generalist |

## 流程文件选择

| complexity | flow file |
|-----------|-----------|
| L1 | flows/L1-light.md |
| L2 | flows/L2-standard.md |
| L3 | flows/L3-full.md |

## 用户强制升降级

用户在 clarify 完成后可指令：
- "用 L3 走" → 切换 flow
- "简单点 L1 就行" → 切换 flow
- "用 X 专家" → 替换 expert

切换后从当前阶段按新配置继续。

## 模糊问题处理

当无法判定 domain 或 complexity 时：
- 先按 generalist + L2 走
- 在 clarify 阶段二次询问以缩小范围

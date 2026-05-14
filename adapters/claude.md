# Claude (Projects) 平台适配

## 平台特性

- 通过 Project Instructions 加载规则
- 支持上传文件作为 Knowledge
- Artifacts 输出长内容
- 无终端能力

## 从 git 克隆后的使用步骤

### 步骤 1：克隆仓库

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee
```

### 步骤 2a：创建 Claude Project（推荐）

1. Claude.ai → Projects → New Project
2. 设置 Project Instructions：
   ```bash
   cat entry.md | pbcopy
   ```
   把内容粘贴到 Project Instructions。

3. 上传 Knowledge 文件：
   - `ETHOS.md`
   - `skills/classify/SKILL.md`
   - `skills/clarify/SKILL.md`
   - `skills/plan/SKILL.md`
   - `skills/review/SKILL.md`
   - `skills/deliver/SKILL.md`
   - 常用 expert 文件

   Claude 会自动用 Knowledge 中的文件回答。

4. 在 Project 内开新对话即可使用。

### 步骤 2b：常规对话

新对话开头粘贴 entry.md 内容。

## Knowledge 上传策略

Claude Projects 的 Knowledge 文件数量有限（视订阅版本，通常 5-30 个）。

推荐优先级：

| 优先级 | 文件 | 理由 |
|--------|------|------|
| ⭐⭐⭐ | ETHOS.md | 全局准则 |
| ⭐⭐⭐ | skills/classify/SKILL.md | 入口 |
| ⭐⭐⭐ | skills/clarify/SKILL.md | 早期阶段必用 |
| ⭐⭐⭐ | skills/plan/SKILL.md | 方案设计核心 |
| ⭐⭐⭐ | skills/review/SKILL.md | 质量门 |
| ⭐⭐ | quality-gates/four-dimensions.md | 评分标准 |
| ⭐⭐ | quality-gates/evidence-chain.md | 证据链规范 |
| ⭐⭐ | experts/<your-domain>.md | 你常用领域的专家 |
| ⭐ | examples/L2-business-plan.md | 完整示例 |

按需取舍。

## 验证

1. 在 Claude Project 内开新对话
2. 提任意问题
3. AI 应进入 UEE 流程

## Claude 优势

- Artifacts 可输出长代码 / 文档不被截断
- Knowledge 检索准确
- Project 内对话保持上下文

## Claude 限制

- 无终端 → 不能跑命令
- 无文件系统 → deliver 用 Artifacts 输出
- Knowledge 文件数有上限

## 升级 UEE

```bash
cd /path/to/uee
git pull origin main

# Project Instructions 需要手动重新粘贴
cat entry.md | pbcopy
# 进入 Claude Project → Edit Instructions

# Knowledge 文件如有变化，删除旧的重新上传
```

## 文件组织规则

通过 Artifacts 组织：
- 每个文件一个 Artifact
- 用户可单独下载
- deliver 摘要中列出所有 Artifacts

# Claude (Projects) 平台适配

## 平台特性

- 通过 Project Instructions 加载规则
- 支持上传文件作为 Knowledge
- Artifacts 输出长内容
- 无终端能力

## 使用步骤

Claude Projects 是 Web 平台，不需要在"项目里激活"。准备好 entry.md 内容粘贴到 Project Instructions。

### 步骤 1：先在本地装好 UEE

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git ~/.uee
```

### 步骤 2：复制 entry.md

```bash
# macOS
cat ~/.uee/entry.md | pbcopy

# Linux
cat ~/.uee/entry.md | xclip -selection clipboard

# Windows (Git Bash)
cat ~/.uee/entry.md | clip
```

### 步骤 3：创建 Claude Project

1. Claude.ai → Projects → New Project
2. Set Project Instructions → 粘贴
3. （可选）上传 Knowledge 文件：

   推荐优先级：

   | 优先级 | 文件 |
   |--------|------|
   | ⭐⭐⭐ | `~/.uee/ETHOS.md` |
   | ⭐⭐⭐ | `~/.uee/skills/classify/SKILL.md` |
   | ⭐⭐⭐ | `~/.uee/skills/clarify/SKILL.md` |
   | ⭐⭐⭐ | `~/.uee/skills/plan/SKILL.md` |
   | ⭐⭐⭐ | `~/.uee/skills/review/SKILL.md` |
   | ⭐⭐ | `~/.uee/quality-gates/four-dimensions.md` |
   | ⭐⭐ | `~/.uee/quality-gates/evidence-chain.md` |
   | ⭐⭐ | `~/.uee/experts/<your-domain>.md` |
   | ⭐ | `~/.uee/examples/L2-business-plan.md` |

4. 在 Project 内开新对话即可使用

## 验证

1. 在 Claude Project 内开新对话
2. 提任意问题
3. AI 应按 UEE 流程响应

## Claude 优势

- Artifacts 可输出长代码 / 文档不被截断
- Knowledge 检索准确
- Project 内对话保持上下文

## Claude 限制

- 无终端 → 不能跑命令
- 无文件系统 → deliver 用 Artifacts 输出
- Knowledge 文件数有上限（视订阅版本）

## 升级 UEE

```bash
cd ~/.uee
git pull origin main

# 重新粘贴 Instructions
cat ~/.uee/entry.md | pbcopy
# 进入 Claude Project → Edit Instructions
# 已上传的 Knowledge 文件如有变化，删除旧的重新上传
```

## 文件组织规则

通过 Artifacts 组织：
- 每个文件一个 Artifact
- 用户可单独下载
- deliver 摘要中列出所有 Artifacts

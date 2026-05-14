# Claude (Projects) 平台适配

## 平台特性

- 通过 Project Instructions 加载规则
- 支持上传文件作为 Knowledge
- Artifacts 可输出长内容
- 无终端能力

## 加载方式

### 方式 1：创建 Claude Project（推荐）

1. Claude → Projects → New Project
2. Project Instructions：粘贴 `entry.md` 全部内容
3. Knowledge：上传以下文件
   - ETHOS.md
   - skills/ 下所有 SKILL.md
   - experts/ 下所有专家身份
   - quality-gates/ 下所有规范

Claude 会自动用 Knowledge 中的文件回答。

### 方式 2：常规对话

新对话开头粘贴 `entry.md` 即可。

## Claude 优势

- Artifacts 适合输出代码/文档（不会被截断）
- Knowledge 让我能引用完整能力树
- Project 内对话保持上下文

## Claude 限制

- 无终端 → 不能跑命令
- 无文件系统 → deliver 时输出 markdown 内容
- Knowledge 文件 5 个上限（视版本）

## 推荐用法

- 全场景适用，特别适合：
  - L1/L2 咨询类问题
  - 文档撰写
  - 代码生成（用 Artifacts 输出）

## 文件组织规则

通过 Artifacts 组织产出：
- 每个文件一个 Artifact
- 用户可单独下载
- 在交付摘要中列出所有 Artifacts

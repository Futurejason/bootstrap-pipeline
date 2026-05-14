# Claude Code 平台适配

## 平台特性

- 通过 `CLAUDE.md` 加载规则
- 完整终端能力
- 支持文件引用（虽然语法不同）
- 支持 sub-agent

## 加载方式

### 方式 1：项目级（推荐）

在项目根目录创建 `CLAUDE.md`，粘贴 `entry.md` 全部内容。

可在 CLAUDE.md 末尾追加引用其他文件：

```markdown
# 完整规则参考

详细规则见：
- ETHOS.md
- skills/classify/SKILL.md
- skills/plan/SKILL.md
...
```

Claude Code 会按需读取这些文件。

### 方式 2：全局级

```bash
mkdir -p ~/.claude/skills/uee/
cp -r universal-expert-engine/* ~/.claude/skills/uee/
```

然后在 `~/.claude/CLAUDE.md` 引用。

## Claude Code 特有能力利用

### 1. 终端命令

execute skill 可以直接跑命令：
- 创建项目目录
- 安装依赖
- 跑测试
- 启动服务

### 2. Bash + Read + Write 组合

- resource skill：读 PDF / 文档
- execute skill：写代码
- review skill：读测试结果

### 3. Sub-agent（如有）

复杂子任务委托：
- 大量文件分析 → sub-agent
- 独立模块开发 → sub-agent

## Claude Code 限制

- 长任务可能超时（建议每阶段独立保存）
- 上下文有限（大项目用 session save/restore）

## 文件组织规则

完全支持 ETHOS 规则。可创建独立项目文件夹。

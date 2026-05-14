# Claude Code 平台适配

## 平台特性

- 通过 `CLAUDE.md` 加载规则
- 完整终端能力
- 文件读写可用

## 从 git 克隆后的安装步骤

### 场景 1：直接在 UEE 仓库内使用

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee

# 一键
./setup.sh

# 或手动：把 entry.md 复制为 CLAUDE.md
cp entry.md CLAUDE.md
```

启动：

```bash
claude
```

### 场景 2：在你的项目里使用

```bash
cd /path/to/your-project
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cp uee/entry.md CLAUDE.md
claude
```

### 场景 3：希望 CLAUDE.md 同时引用 UEE 详细文件

```bash
cp uee/entry.md CLAUDE.md
cat >> CLAUDE.md << 'EOF'

## 详细规则参考

需要更细的规则时，按需读取以下文件：

- 行为准则：uee/ETHOS.md
- 编排逻辑：uee/orchestrator/ORCHESTRATOR.md
- 路由规则：uee/orchestrator/routing-rules.md
- 四维评分：uee/quality-gates/four-dimensions.md
- 证据链：uee/quality-gates/evidence-chain.md
- 单 Skill 详情：uee/skills/<skill-name>/SKILL.md
- 专家身份：uee/experts/<expert-name>.md
- 模板：uee/templates/
EOF
```

Claude Code 会按需读取这些文件。

## 验证

```bash
# 启动 Claude Code
claude

# 在 chat 里随便问一个问题
# AI 应该按 UEE 流程响应（先 classify ...）
```

如果没生效：
- 确认 CLAUDE.md 在当前工作目录
- 确认 entry.md 内容已正确复制（`head -20 CLAUDE.md` 应能看到 UEE 标题）

## Claude Code 特有能力利用

### 1. 终端命令
execute skill 可直接跑：
- 创建项目目录
- 安装依赖
- 跑测试

### 2. 文件读写
- resource skill：读 PDF / 文档
- execute skill：写代码
- review skill：读测试结果

### 3. Sub-agent（如有）
复杂子任务委托。

## 升级 UEE

```bash
cd /path/to/uee
git pull origin main

# 你的项目里需要重新生成 CLAUDE.md
cd /path/to/your-project
cp uee/entry.md CLAUDE.md
```

## 文件组织规则

按 ETHOS 规则。Claude Code 终端可创建独立项目文件夹。

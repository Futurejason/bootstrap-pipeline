# Claude Code 平台适配

## 平台特性

- 通过 `CLAUDE.md` 加载规则
- 完整终端能力
- 文件读写可用

## 在你的项目里激活 UEE

### 推荐方式：用 install.sh

```bash
cd ~/projects/my-app
~/.uee/install.sh
# 或仅 Claude Code
~/.uee/install.sh --platform=claude-code
```

会在你的项目里生成 `CLAUDE.md`（已存在的会备份为 `CLAUDE.md.bak`）。

### 启动 Claude Code

```bash
cd ~/projects/my-app   # 必须在项目目录里启动
claude
```

`CLAUDE.md` 会自动加载。

### 手动方式

```bash
cd ~/projects/my-app

# 直接复制 entry.md
cp ~/.uee/entry.md CLAUDE.md
```

### 让 CLAUDE.md 引用 UEE 详细文件（高级）

如果你希望 Claude Code 能按需读取 UEE 的所有 SKILL 详细规则：

```bash
cat ~/.uee/entry.md > CLAUDE.md
cat >> CLAUDE.md << EOF

## 详细规则参考

需要更细的规则时，按需读取以下文件：
- 行为准则：~/.uee/ETHOS.md
- 编排：~/.uee/orchestrator/ORCHESTRATOR.md
- 单 Skill：~/.uee/skills/<skill-name>/SKILL.md
- 专家身份：~/.uee/experts/<expert-name>.md
EOF
```

Claude Code 会按需读取这些文件。

## 验证

```bash
cd ~/projects/my-app
claude

# 提任意问题，AI 应按 UEE 流程响应
```

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
cd ~/.uee
git pull origin main

# 各项目重新激活
cd ~/projects/my-app
~/.uee/install.sh --platform=claude-code
```

## 卸载

```bash
cd ~/projects/my-app
~/.uee/uninstall.sh --platform=claude-code
```

## 文件组织规则

按 ETHOS 规则，可创建独立项目子目录。Claude Code 终端可执行 `mkdir`。

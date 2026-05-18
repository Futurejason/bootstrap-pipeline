# Universal Expert Engine (UEE)

> 全能行业专家引擎 v1.0.0
> 用户只需要：提问 → 完善条件 → 确认方案 → 拿到结果。

## 这是什么

UEE 是一个让 AI 自主解决任何领域问题的**工具**。它不是一个项目模板——你**在自己的项目里**激活它，让你正在使用的 AI 工具（Cursor、Claude Code、Kiro 等）按 UEE 的标准流程响应。

## 快速开始（3 步）

### 第 1 步：下载 UEE（一次性）

```bash
# 默认装到 ~/.uee
git clone https://github.com/Futurejason/bootstrap-pipeline.git ~/.uee

# 或装到你想要的位置
git clone https://github.com/Futurejason/bootstrap-pipeline.git /your/path/uee
```

### 第 2 步：在你的项目里激活

```bash
# 进入你自己的项目
cd ~/projects/my-app

# 激活 UEE（自动检测平台）
~/.uee/install.sh
```

完成。重启你的 IDE（Cursor / Kiro / Windsurf），AI 就会按 UEE 流程响应了。

### 第 3 步：开始使用

在 IDE 里随便问 AI 一个问题，AI 会先做问题分类（classify）→ 澄清（clarify）→ 方案（plan）→ 执行（execute）→ 交付（deliver）。

## 安装模式

| 模式 | 命令 | 行为 |
|------|------|------|
| 全局（默认）| `~/.uee/install.sh` | 你的项目里只生成轻量配置文件，引用全局 UEE |
| 局部 | `~/.uee/install.sh --local` | 把 UEE 复制到你项目的 `.uee/` 目录，项目自包含 |
| 指定路径 | `~/.uee/install.sh --uee-dir=/path` | 用别处的 UEE |
| 指定项目 | `~/.uee/install.sh --target=/path/proj` | 不在当前目录而在指定目录激活 |
| 指定平台 | `~/.uee/install.sh --platform=cursor` | 仅配置某个平台（跳过交互） |
| 自动确认 | `~/.uee/install.sh --yes` | 自动安装检测到的全部（CI 友好） |

## 多平台并存

**完全支持**。例如同一台电脑上你既用 Kiro 又用 Cursor：

```bash
cd ~/projects/my-app

# 默认交互式，从菜单多选
~/.uee/install.sh
# 选择: 1,2  → 同时配置 kiro 和 cursor

# 或一次指定多个
~/.uee/install.sh --platform=kiro --platform=cursor
```

各平台的配置文件互相独立，不会冲突：
- Kiro 用 `.kiro/steering/uee.md`
- Cursor 用 `.cursorrules`
- Claude Code 用 `CLAUDE.md`
- Windsurf 用 `.windsurfrules`

也可以**增量安装**——先装 kiro，过几天再加 cursor：
```bash
~/.uee/install.sh --platform=kiro      # 第一次
~/.uee/install.sh --platform=cursor    # 之后追加
```

之前已安装的平台不受影响。

## 卸载

```bash
cd ~/projects/my-app
~/.uee/uninstall.sh
```

会清理 UEE 写入的文件（仅识别 `<!-- UEE-MANAGED -->` 标记的文件，不动你自己写的）。如有备份（`.bak`），会提示恢复。

## 激活后会发生什么

`install.sh` 在你的项目里生成的文件（按检测到的平台）：

| 平台 | 生成的文件 | 大小 | 含义 |
|------|-----------|------|------|
| Kiro | `.kiro/steering/uee.md` | <1KB | 引用 UEE 仓库的 steering 文件 |
| Cursor | `.cursorrules` | ~8KB | UEE 的 entry.md 副本 |
| Windsurf | `.windsurfrules` | ~8KB | UEE 的 entry.md 副本 |
| Claude Code | `CLAUDE.md` | ~8KB | UEE 的 entry.md 副本 |

如果该文件已存在且非 UEE 管理 → 自动备份为 `.bak`。

## ChatGPT / Claude Projects（Web 平台）

无文件系统，需要手动复制 entry.md 内容粘贴到 Instructions：

```bash
# macOS
cat ~/.uee/entry.md | pbcopy

# Linux
cat ~/.uee/entry.md | xclip -selection clipboard

# Windows (Git Bash)
cat ~/.uee/entry.md | clip
```

然后：
- ChatGPT → 创建 GPT → Instructions 字段粘贴
- Claude → 创建 Project → Project Instructions 粘贴

## 升级

```bash
cd ~/.uee
git pull origin main

# 各项目里需要重新 install 一次以拉取最新内容（可选，全局模式会自动跟进；局部模式必须重跑）
cd ~/projects/my-app
~/.uee/install.sh
```

## 三档复杂度

| 档位 | 适用 | 阶段数 |
|------|------|--------|
| L1 轻量 | FAQ、单点问答、概念解释 | 4 阶段 |
| L2 标准 | 方案设计、文档撰写、行业咨询 | 6 阶段 |
| L3 完整 | 项目交付、复杂系统设计 | 7 阶段 |

## 9 个独立可用 Skill

每个 skill 既可单独调用，也能整体编排：

`classify` `clarify` `resource` `plan` `design` `execute` `review` `deliver` `refine`

## 用户介入仅 4 处

| 节点 | 时机 | 用户做什么 |
|------|------|-----------|
| 🔵 P1 | clarify 完成后 | 确认理解 |
| 🔵 P2 | plan 完成后 | 选方案 |
| 🔴 P3 | 遇阻塞 | 二选一/多选一 |
| 🟢 P4 | deliver 完成后 | 验收 |

## 11 个动态专家身份

软件工程师 / 解决方案架构师 / 产品经理 / 内容创作者 / 商业咨询 / 数据分析师 / 法律顾问 / 医疗参考 / 营销策略师 / 教育工作者 / 通用兜底

## 验证 UEE 是否生效

激活后在 IDE 提任意问题，AI 应该：

1. 不直接回答，而是先输出 `[classify] domain=... complexity=...`
2. 关键论断带 `【论断】【论据】【来源】【可信度】` 三元组
3. 在 P1/P2/P4 节点暂停等用户

如果 AI 直接回答没有上述结构 → IDE 没重启，或文件路径错了。详见 [INSTALL.md](INSTALL.md) 故障排查。

## 项目结构（UEE 仓库内部）

```
.uee/                              # 默认安装位置
├── install.sh                     # 激活脚本（在你的项目里运行）
├── uninstall.sh                   # 卸载脚本
├── entry.md                       # 引擎核心
├── ETHOS.md                       # 行为准则
├── ARCHITECTURE.md                # 架构设计
├── INSTALL.md                     # 详细安装指南
├── skills/                        # 9 个独立 skill
├── orchestrator/                  # 流程编排
├── experts/                       # 11 个专家身份
├── quality-gates/                 # 5 个质量保障组件
├── adapters/                      # 平台适配文档
├── templates/                     # 输出模板
└── examples/                      # 完整示例
```

## 设计原则

1. **复杂度自适应**：AI 自动判断 L1/L2/L3
2. **专家身份动态**：根据领域加载对应专家
3. **四维质量门**：完备性/准确性/一致性/可行性，每阶段强制通过
4. **证据链可追溯**：每个论断有论据 → 来源 → 可信度三元组
5. **失败三层降级**：重试 → 备选 → 简化上报

## 版本

v1.0.0 — 初始发布

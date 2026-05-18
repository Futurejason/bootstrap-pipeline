# UEE 安装指南

> 在你自己的项目里激活 Universal Expert Engine。

## 概念

UEE 是工具，你的项目是宿主。安装的本质是：在你的项目里写一个小配置文件（如 `.cursorrules`），告诉 AI 工具按 UEE 流程工作。

## 第 1 步：下载 UEE（一次性）

```bash
# 默认装到 ~/.uee
git clone https://github.com/Futurejason/bootstrap-pipeline.git ~/.uee

# 或装到任意位置
git clone https://github.com/Futurejason/bootstrap-pipeline.git /your/path/uee
```

UEE 仓库本身只是源文件，不需要安装到系统。`install.sh` 会从这个目录引用或复制内容。

## 第 2 步：在你的项目里激活

进入你的项目目录，运行 install.sh：

```bash
cd ~/projects/my-app
~/.uee/install.sh
```

**默认是交互式菜单**——脚本会列出检测到的平台并显示状态，你来选要安装哪些：

```
检测到当前可用的平台：

  [1] kiro         ✓ 已检测到 | 未安装
  [2] cursor       ✓ 已检测到 | 未安装
  [3] windsurf       未检测到
  [4] claude-code  ✓ 已检测到 | 未安装

选择要安装的平台：
  - 输入编号（多选用逗号分隔）：例 1,2
  - 输入平台名：例 kiro,cursor
  - 输入 a / all：全部
  - 输入 d / detected：检测到的全部
  - 输入 q / 留空：退出
```

支持的输入：
- `1` 或 `1,2,4` — 按编号
- `kiro` 或 `kiro,cursor` — 按名字
- `a` / `all` — 安装全部 4 个
- `d` / `detected` — 安装检测到的全部
- `q` 或 直接回车 — 退出

## 多平台并存

同一台机器上同时用多个 AI 工具？没问题，UEE 支持任意组合：

```bash
# 一次配置 Kiro + Cursor
~/.uee/install.sh --platform=kiro --platform=cursor

# 或者交互菜单里选 1,2
~/.uee/install.sh
```

各平台配置文件互不影响：
| 平台 | 配置文件 |
|------|---------|
| Kiro | `.kiro/steering/uee.md` |
| Cursor | `.cursorrules` |
| Claude Code | `CLAUDE.md` |
| Windsurf | `.windsurfrules` |

**增量安装**：之前装了 kiro，今天再加 cursor？

```bash
~/.uee/install.sh --platform=cursor   # 之前的 kiro 配置不受影响
```

## 安装选项

### 全局模式（默认，推荐）

```bash
~/.uee/install.sh
```

行为：在你项目里只生成轻量配置文件，文件内容引用全局 UEE 仓库（`~/.uee`）。

适合：希望 UEE 升级时所有项目自动跟进。

注意：把项目复制到没有 UEE 的另一台机器时，需要先安装 UEE。

### 局部模式

```bash
~/.uee/install.sh --local
```

行为：把 UEE 整个复制到你项目里的 `.uee/` 子目录。

适合：希望项目自包含、可移植。

注意：UEE 升级时需要重新跑 `~/.uee/install.sh --local` 才能更新到项目里的副本。

### 指定 UEE 仓库位置

```bash
~/.uee/install.sh --uee-dir=/path/to/uee
```

如果 UEE 不在 `~/.uee`，用这个参数指定。脚本本身在 UEE 仓库里，所以默认会用脚本所在的目录作为 UEE 根。

### 指定目标项目

```bash
~/.uee/install.sh --target=/path/to/my-app
```

如果不想在当前目录激活，用这个参数指定目标项目。

### 自动确认（CI 友好）

```bash
~/.uee/install.sh --yes
```

跳过交互菜单，自动安装检测到的所有平台。如果检测不到任何平台，脚本会失败退出（CI 应该用 `--platform=` 显式指定）。

## 平台说明

### 自动可处理（4 个）

| 平台 | 特征 | 生成文件 |
|------|------|---------|
| Kiro | 项目里有 `.kiro/` 目录 | `.kiro/steering/uee.md` |
| Cursor | 系统装了 `cursor` 命令 | `.cursorrules` |
| Windsurf | 系统装了 `windsurf` 命令 | `.windsurfrules` |
| Claude Code | 系统装了 `claude` 命令 | `CLAUDE.md` |

### 需要手动配置（Web 平台）

| 平台 | 配置位置 |
|------|---------|
| ChatGPT GPTs | Instructions 字段 |
| Claude Projects | Project Instructions |

复制 entry.md 到剪贴板：

```bash
# macOS
cat ~/.uee/entry.md | pbcopy

# Linux
cat ~/.uee/entry.md | xclip -selection clipboard

# Windows (Git Bash)
cat ~/.uee/entry.md | clip
```

然后到对应 Web 平台粘贴。

## 第 3 步：验证生效

激活后，重启你的 IDE，提任意问题。AI 应该：

1. 输出 `[classify]` 阶段标记
2. 关键论断带 `【论断】【论据】【来源】【可信度】` 标注
3. 在 P1/P2/P4 节点暂停等待用户

如果 AI 直接回答没有上述结构：

| 症状 | 检查 |
|------|------|
| Cursor 没生效 | 重启 Cursor；确认 `.cursorrules` 在项目根 |
| Kiro 没生效 | 重启 Kiro；查看 `.kiro/steering/uee.md` 路径是否对 |
| Claude Code 没生效 | 重启 `claude` 命令；CLAUDE.md 在当前目录 |

## 卸载

```bash
cd ~/projects/my-app
~/.uee/uninstall.sh
```

或：

```bash
~/.uee/uninstall.sh --target=/path/to/my-app
```

会扫描目标项目，**仅删除**含 `<!-- UEE-MANAGED -->` 标记的文件，不会动你自己写的：

- `.cursorrules`
- `.windsurfrules`
- `CLAUDE.md`
- `.kiro/steering/uee.md`
- `.uee/`（局部模式产生的目录）

如有 `.bak` 备份（说明你有原配置被 UEE 备份过），会提示是否恢复。

## 升级 UEE

```bash
cd ~/.uee
git pull origin main
```

后续：
- **全局模式**：所有项目自动跟进，不需要重新 install
- **局部模式**：每个使用了局部模式的项目需要重新 `~/.uee/install.sh --local`

## 故障排查

### Q: 脚本报"UEE 仓库不存在"
确认 `~/.uee/entry.md` 存在。如果你装在别处，用 `--uee-dir=`。

### Q: 想换 UEE 安装位置
```bash
mv ~/.uee /new/path/uee
# 各项目重新 install 一次
cd ~/projects/my-app
/new/path/uee/install.sh
```

### Q: install 后 AI 还是不按 UEE 流程
检查清单：
- [ ] IDE 已重启？
- [ ] 配置文件存在？（`ls -la` 看下）
- [ ] 配置文件含 `<!-- UEE-MANAGED -->` 标记？
- [ ] 配置文件指向的路径有效？（cat 看下）

### Q: 我项目里已经有 .cursorrules 怎么办
install.sh 会自动备份成 `.cursorrules.bak`，然后写入 UEE 内容。卸载时会提示是否恢复备份。

### Q: 多个项目要不要每个都装一次
是的。但如果用全局模式，每个项目只是写个轻量配置文件，UEE 本体只装一次。

### Q: 想在 CI 里自动化
```bash
~/.uee/install.sh --target=$REPO_DIR --platform=cursor   # 跳过交互
```

如果脚本检测不到平台又没指定 `--platform`，会进入交互菜单。CI 中务必指定 `--platform`。

## 几个常见配置

### 团队共享 UEE 配置（推荐做法）

仓库内提交 UEE 配置文件，团队成员只需 clone 仓库即可：

```bash
# 团队管理员一次性
cd ~/team-project
~/.uee/install.sh --local                  # 局部模式，UEE 入仓
git add .uee/ .cursorrules CLAUDE.md
git commit -m "chore: enable UEE for team"
git push

# 团队成员
git clone <repo>
# 直接打开 IDE 即可，UEE 已嵌在仓库里
```

### 仅单平台使用

```bash
~/.uee/install.sh --platform=cursor
```

### 多个项目批量激活

```bash
for proj in ~/projects/*/; do
  ~/.uee/install.sh --target="$proj"
done
```

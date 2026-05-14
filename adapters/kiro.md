# Kiro 平台适配

## 平台特性

- 支持文件引用 `#[[file:path]]`
- 支持 steering（自动加载规则）
- 支持 specs（结构化需求文档）
- 内置 task 工具链

## 在你的项目里激活 UEE

### 推荐方式：用 install.sh

```bash
# 进入你自己的项目
cd ~/projects/my-app

# 激活（自动检测平台）
~/.uee/install.sh

# 或仅配置 Kiro
~/.uee/install.sh --platform=kiro
```

脚本会自动：
1. 创建 `.kiro/steering/uee.md`
2. 计算从 steering 出发到 UEE 仓库的相对路径
3. 写入 `#[[file:...]]` 引用

### 手动方式

```bash
cd ~/projects/my-app
mkdir -p .kiro/steering

cat > .kiro/steering/uee.md << 'EOF'
---
inclusion: auto
---

<!-- UEE-MANAGED -->
# Universal Expert Engine

#[[file:绝对路径或相对路径/entry.md]]
#[[file:绝对路径或相对路径/ETHOS.md]]
... 其他文件
EOF
```

注意：相对路径要从 `.kiro/steering/` 出发计算。手动写易出错，建议用 `install.sh` 自动算。

## 验证

1. 重启 Kiro
2. 在 chat 输入 "你好"
3. AI 应输出 `[classify] domain=... complexity=...` 而不是直接回答

如果没生效：
- 检查 `.kiro/steering/uee.md` 存在
- 检查里面的 `#[[file:]]` 路径是否能找到 entry.md
- Kiro 是否已重启

## 局部 vs 全局模式（Kiro 特有的优势）

Kiro 的文件引用机制让两种模式效果几乎一致，但有微小差异：

| 模式 | steering 路径 | UEE 升级 | 项目可移植性 |
|------|--------------|---------|-------------|
| 全局 | 指向 `~/.uee/entry.md` | 自动跟进 | 需要目标机器有 `~/.uee` |
| 局部 | 指向 `.uee/entry.md` | 需重新 install | 完全可移植 |

## Kiro 特有能力利用

### 1. task_list / task_update 工具
L3 流程的多模块执行可拆成 task。

### 2. invoke_sub_agent
复杂子任务委托给 sub-agent。

### 3. user_input 工具
P1/P2/P3/P4 决策点用结构化选项。

## 升级 UEE

```bash
cd ~/.uee
git pull origin main
```

全局模式下 Kiro steering 自动跟进（用的相对/绝对路径都指向 ~/.uee）。
局部模式需重新跑 `install.sh --local`。

## 卸载

```bash
cd ~/projects/my-app
~/.uee/uninstall.sh --platform=kiro
```

会清理 `.kiro/steering/uee.md`，如果 `.kiro/steering/` 空了一并删除。

## 文件组织规则

按 ETHOS 规则，每个新任务的产出放在独立 kebab-case 目录。

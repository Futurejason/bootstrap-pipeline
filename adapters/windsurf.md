# Windsurf 平台适配

## 平台特性

- 通过 `.windsurfrules` 加载规则
- 类似 Cursor 体验
- 终端可用

## 从 git 克隆后的安装步骤

### 场景 1：直接在 UEE 仓库内使用

```bash
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cd uee

# 一键
./setup.sh

# 或手动
cp entry.md .windsurfrules
```

### 场景 2：在你的项目里使用

```bash
cd /path/to/your-project
git clone https://github.com/Futurejason/bootstrap-pipeline.git uee
cp uee/entry.md .windsurfrules
```

### 场景 3：附加常用 skill

```bash
cat uee/entry.md > .windsurfrules
echo "" >> .windsurfrules
cat uee/skills/classify/SKILL.md >> .windsurfrules
cat uee/skills/plan/SKILL.md >> .windsurfrules
cat uee/skills/review/SKILL.md >> .windsurfrules
```

## 验证

1. 重启 Windsurf
2. 提任意问题
3. AI 应走 UEE 流程

## 升级 UEE

```bash
cd /path/to/uee
git pull origin main
cd /path/to/your-project
cp uee/entry.md .windsurfrules
```

## 文件组织规则

同 Cursor，按 ETHOS 规则。

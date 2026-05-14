# Cursor 平台适配

## 平台特性

- 通过 `.cursorrules` 文件加载规则
- 支持 Settings → Rules for AI 配置
- 有终端访问能力
- 文件读写可用

## 加载方式

### 方式 1：项目级（推荐）

在项目根目录创建 `.cursorrules`，粘贴 `entry.md` 全部内容。

### 方式 2：全局级

打开 Cursor → Settings → Rules for AI → 粘贴 `entry.md` 内容。

## Cursor 特有能力利用

### 1. 利用 Cmd+K / Cmd+L

- Cmd+L 适合用 UEE 的整体流程（深度对话）
- Cmd+K 适合调用单 skill（如"用 review 检查这块代码"）

### 2. 文件上下文

Cursor 自动加载当前打开文件作为上下文：
- 在 resource skill 阶段会自动包含
- 减少用户手动粘贴的需要

### 3. @file / @folder 引用

用户可显式引用文件：
- `@docs/requirements.md 帮我 review` → 触发 review skill

## Cursor 限制

### 不支持文件引用
`.cursorrules` 单文件，不能像 Kiro 那样 `#[[file:...]]` 加载多文件。

### 解决：将常用 skill 内嵌

`.cursorrules` 中除 entry.md 外，可附加最常用 skill 内容（建议：classify / plan / review）。

## 文件组织规则

按 ETHOS 规则，新任务产出放独立目录。Cursor 终端可执行 `mkdir`。

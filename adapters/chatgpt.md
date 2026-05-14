# ChatGPT / GPTs 平台适配

## 平台特性

- 通过 GPTs 的 Instructions 加载规则
- 单文件、长度有限
- 不支持文件引用
- 无终端能力（除非用 Code Interpreter）

## 加载方式

### 方式 1：创建自定义 GPT（推荐）

1. 进入 ChatGPT → Explore GPTs → Create
2. Instructions 字段粘贴 `entry.md` 全部内容
3. Name: "Universal Expert Engine"
4. Description: "全能行业专家引擎"
5. （可选）上传 `experts/` 下的专家身份文件作为 Knowledge

### 方式 2：常规对话注入

在新对话开头粘贴 `entry.md` 内容作为系统提示。

## ChatGPT 限制

### Instructions 长度限制
ChatGPT GPTs 的 Instructions 约 8000 字符。需要精简。

### 解决方案
仅加载 `entry.md` 的引擎核心部分（不含完整能力树）。能力子集如下：
- classify / clarify / plan / execute / review / deliver 的核心逻辑（简化版）
- 不加载 design 和 refine 的详细规范（按需简述）

### 文件系统能力
- 无终端 → 无法创建项目目录
- 解决：deliver 时输出完整 markdown 内容，让用户手动保存

### Code Interpreter 模式
如果用户开启 Code Interpreter：
- execute skill 可生成并运行 Python
- 可下载文件

## 推荐用法

- 适合：方案咨询、文档撰写、行业分析（L1/L2）
- 不适合：完整软件项目交付（L3，因为没有持续的文件系统）

## 文件组织规则

无文件系统时，改为：
- 在 markdown 中用清晰的章节分隔
- 让用户自行保存到本地

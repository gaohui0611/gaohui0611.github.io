---
title: OpenAI Skills：让 AI 拥有超能力
date: 2026-03-10 20:05:00
tags: [OpenAI, AI, 技能]
categories: 技术
---

# OpenAI Skills：让 AI 代理拥有可复用的专业技能

在 AI 编程助手日益普及的今天，如何让它们不仅能回答问题，还能**掌握特定领域的专业技能**？OpenAI 推出的 **Skills（技能）系统** 给出了一个优雅的答案。这是一个开放的技能标准，让 AI 代理可以像人类一样，通过学习特定的"技能包"来完成复杂任务。

---

## 什么是 Agent Skills？

Agent Skills 是一套**可发现、可复用、可分享**的能力包。每个 Skill 本质上是一个包含以下内容的文件夹：

- **SKILL.md** - 核心指令和元数据（必需）
- **scripts/** - 可执行脚本（可选）
- **references/** - 参考文档（可选）
- **assets/** - 模板和资源（可选）
- **openai.yaml** - 外观和依赖配置（可选）

这种设计理念非常巧妙：**一次编写，到处使用**。团队可以将最佳实践封装成 Skill，在不同项目间共享，甚至贡献给社区。

---

## 核心架构：渐进式披露

Skills 采用了**渐进式披露（Progressive Disclosure）**的设计：

```
启动时：只加载技能的名称和描述
使用时：按需加载完整的指令和参考资料
```

这种设计既保证了启动速度，又确保了 AI 在需要时能获得充分的上下文。

### 两种调用方式

**1. 显式调用**
- 使用 `/skills` 命令
- 或输入 `$` 提及技能（如 `$skill-creator`）

**2. 隐式调用**
- AI 根据任务描述自动匹配相关技能

---

## 技能存储的层级设计

Codex 从多个位置读取技能，形成了一个清晰的优先级体系：

| 层级 | 位置 | 用途 |
|------|------|------|
| **SYSTEM** | 内置于 Codex | 通用技能，如 skill-creator、plan |
| **ADMIN** | `/etc/codex/skills` | 系统级 SDK 脚本和默认技能 |
| **USER** | `~/.agents/skills` | 用户个人技能，跨仓库可用 |
| **REPO** | `.agents/skills` | 项目专属技能 |
| **REPO_ROOT** | `$REPO_ROOT/.agents/skills` | 仓库根级共享技能 |

这种设计让技能管理既灵活又有序：个人偏好放在用户目录，团队协作放在仓库目录，系统默认放在系统目录。

---

## 实战：创建和使用技能

### 创建新技能

最简单的方式是使用内置的 `$skill-creator`：

```bash
# 告诉 AI 你想创建什么技能
$skill-creator
# 然后描述："创建一个帮助生成 React 组件的技能"
```

如果你想先规划再创建，可以安装实验性的 `$create-plan`：

```bash
$skill-installer install the create-plan skill from the .experimental folder
```

### 手动创建

你也可以手动创建技能文件夹，只需包含一个 `SKILL.md`：

```markdown
---
name: react-component-gen
description: 帮助生成符合团队规范的 React 组件
---

当用户要求创建 React 组件时：

1. 检查项目是否使用 TypeScript
2. 遵循函数组件 + Hooks 的模式
3. 添加 JSDoc 注释
4. 使用命名导出
5. 包含基本的 PropTypes/TypeScript 接口
```

### 安装社区技能

OpenAI 维护了一个精选技能库：

```bash
# 安装 Linear 集成
$skill-installer install the linear skill from the .experimental folder

# 安装 Notion 集成
$skill-installer notion-spec-to-implementation

# 安装 GitHub PR 评论技能
$skill-installer gh-address-comments
```

---

## 技能与 Agent Loop 的协作

Skills 并非独立运行，而是深度集成在 Codex 的 **Agent Loop** 中：

```
用户输入 → 构建 Prompt → 模型推理 → 工具调用 → 结果反馈
                ↑
         [Skills 在这里注入]
```

在构建 Prompt 时，Codex 会：
1. 加载系统指令（sandbox 说明、权限等）
2. 加载用户配置（developer_instructions）
3. 加载项目文档（AGENTS.md）
4. **加载激活的 Skills**
5. 最后添加用户输入

这种层级确保了 Skills 的指令既有足够的上下文，又不会淹没核心任务。

---

## 技能规范：开放标准

OpenAI Skills 基于 **Agent Skills Open Standard**，这是一个开放的规范，意味着：

- **跨平台兼容** - 不局限于 Codex，任何支持该标准的 Agent 都能使用
- **社区驱动** - 任何人都可以创建和分享技能
- **版本可控** - 技能可以独立迭代，不影响核心系统

---

## 实际应用场景

### 1. 团队规范固化
将团队的代码规范、提交规范、测试要求封装成 Skill，确保 AI 生成的代码始终符合标准。

### 2. 领域知识注入
为特定业务领域创建 Skill，比如：
- 金融数据处理的合规要求
- 医疗应用的隐私保护规则
- 电商系统的订单状态流转

### 3. 工具链集成
封装常用工具的使用方式：
- 数据库迁移命令
- 部署流程
- 监控告警处理

### 4. 新手引导
为新人创建项目入门 Skill，包含：
- 环境搭建步骤
- 常见错误排查
- 代码提交流程

---

## 与其他 AI 工具的关系

| 工具 | 定位 | 与 Skills 的关系 |
|------|------|-----------------|
| **Codex** | AI 编程助手 | Skills 的主要宿主，提供运行时环境 |
| **MCP** | 工具协议 | Skills 可以使用 MCP 工具，两者互补 |
| **CCPM** | 项目管理 | 可以用 Skills 封装 CCPM 的工作流 |
| **Claude-Mem** | 记忆系统 | Skills 提供短期专业能力，记忆系统提供长期上下文 |

---

## 给开发者的启示

OpenAI Skills 的设计给我们几个重要启示：

### 1. 提示工程的新范式
与其在每次对话中重复说明要求，不如将最佳实践封装成可复用的 Skill。

### 2. 渐进式上下文管理
不是一次性加载所有信息，而是按需加载，这在长对话中尤为重要。

### 3. 分层配置架构
系统级 → 用户级 → 项目级 → 任务级，这种分层让配置既有默认值又能灵活覆盖。

### 4. 开放标准的力量
通过开放标准，Skills 可以跨平台使用，形成真正的生态系统。

---

## 快速上手

```bash
# 1. 安装 Codex CLI
npm install -g @openai/codex

# 2. 启动并尝试内置技能
codex
# 输入: $skill-creator 帮我创建一个生成 API 文档的技能

# 3. 安装社区技能
$skill-installer install the create-plan skill from the .experimental folder

# 4. 查看所有可用技能
/skills
```

---

## 总结

OpenAI Skills 代表了 AI 编程助手向**专业化、可定制化**演进的重要一步。它让 AI 不再是一个通用的聊天机器人，而是可以掌握特定技能、遵循团队规范的**专业助手**。

对于团队来说，Skills 是知识沉淀和传承的新方式；对于个人来说，Skills 是提升效率的利器；对于社区来说，Skills 是协作和共享的基础设施。

随着越来越多的开发者和团队开始创建和分享 Skills，我们可以期待一个丰富的技能生态系统的形成，让 AI 编程助手真正成为一个**可扩展、可定制、可协作**的智能伙伴。

---

**延伸阅读：**
- [OpenAI Skills GitHub](https://github.com/openai/skills)
- [Agent Skills 规范文档](https://developers.openai.com/codex/skills/)
- [创建自定义技能指南](https://developers.openai.com/codex/skills/create-skills)

---

*本文基于 OpenAI Skills 开源项目分析整理，技能系统正在快速发展中，建议关注官方文档获取最新信息。*

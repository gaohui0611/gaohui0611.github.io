---
title: Claude-Mem：让 Claude 拥有持久记忆的革命性插件
date: 2026-03-10 19:40:00
tags: [Claude, AI, 插件]
categories: 技术
---

Claude-Mem：让 Claude 拥有持久记忆的革命性插件

## 引言
在使用 AI 助手编程时，你是否遇到过这样的困扰：每次开启新的对话，AI 都忘记了之前的项目细节？需要反复解释上下文，浪费大量时间。今天，我们要介绍一个解决这个问题的开源项目——**Claude-Mem**，它让 Claude 拥有了真正的持久记忆。

## 什么是 Claude-Mem？
Claude-Mem 是一个专为 Claude Code 设计的插件，它能够：
自动捕获 Claude 在编码会话中的所有操作，使用 AI 进行智能压缩，并在未来会话中注入相关上下文。

简单来说，就是让你的 Claude 助手能够记住你们之前的所有对话和项目细节，即使会话结束或重新连接，也能保持知识的连续性。

## 核心功能
### 🧠 持久记忆（Persistent Memory）
自动记录：所有的工具使用记录、用户的指令和 AI 的回复、项目文件的变化、代码修改历史

### 📊 渐进式披露（Progressive Disclosure）
三层设计：
第一层：快速索引（~50-100 tokens/条）
第二层：时间线上下文（按需加载）
第三层：完整详情（~500-1000 tokens/条）

### 🔍 智能搜索（Skill-Based Search）
search：全文搜索记忆索引
timeline：获取时间线上下文
get_observations：获取完整观察详情

### 🖥️ Web 查看器（Web Viewer UI）
地址：http://localhost:37777
功能：实时查看记忆流、搜索历史记录、查看观察详情

### 🔒 隐私控制（Privacy Control）
使用 <private> 标签保护敏感信息不被存储

### 🤖 全自动操作（Automatic Operation）
自动捕获会话内容、自动生成摘要、自动注入相关上下文、自动管理存储空间

## 技术架构
### 核心组件
生命周期钩子、Worker 服务、SQLite 数据库、Chroma 向量数据库

### 6 个生命周期钩子
SessionStart、UserPromptSubmit、PostToolUse、Stop、SessionEnd、Smart Install

### 混合搜索架构
语义搜索、关键词搜索、融合排序

### 渐进式披露工作流程
用户提问 → search 获取索引 → timeline 获取时间线上下文 → get_observations 获取完整详情

## 快速开始
### 安装步骤
1. 添加插件市场：/plugin marketplace addthedotmack/claude-mem
2. 安装插件：/plugin install claude-mem
3. 重启 Claude Code

### 验证安装
访问 http://localhost:37777、使用 /mem-search 命令、测试上下文加载

## 实际应用场景
### 场景一：长期项目开发
自动记录代码修改和决策、新会话自动加载项目上下文、直接询问历史决策

### 场景二：Bug 修复追踪
搜索相关代码修改和讨论、快速回顾解决方案

### 场景三：知识积累
自动记录技术决策、形成可查询的知识库

## 高级功能
### 上下文配置（Context Configuration）
精细控制哪些内容会被注入到上下文中

### Beta 功能：无尽模式（Endless Mode）
会话永远不会真正结束、上下文持续累积

### Claude Desktop 集成
跨平台同步上下文、统一的记忆管理

## 最佳实践
### 上下文工程（Context Engineering）
定期清理过时的记忆、使用标签标记重要的决策、对敏感信息使用 <private> 标签

### 渐进式披露策略
先用 search 快速扫描、再用 timeline 了解上下文、最后用 get_observations 查看详情

### 隐私保护
安全第一，敏感信息绝不存储

## 性能与成本
### Token 成本优化
加载上下文节省 90%、搜索记忆节省 90%

### 存储管理
自动压缩、定期清理、存储优化

## 总结
Claude-Mem 解决了 AI 助手在长期使用中的核心痛点——上下文丢失。
记住之前的所有对话和决策、理解项目的完整上下文、搜索历史记录快速定位信息、保护隐私和敏感信息。

对于长期使用 Claude Code 的开发者来说，这是一个必备的工具。

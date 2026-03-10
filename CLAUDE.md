# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

Hexo 静态博客，使用 Matery 主题，通过 GitHub Actions 自动部署到 GitHub Pages。

## 常用命令

```bash
# 本地预览 (http://localhost:4000)
npm run server

# 生成静态文件
npm run build

# 清除缓存
npm run clean

# 创建新文章
./new-post.sh "文章标题"
# 或
npx hexo new "文章标题"
```

## 架构要点

- **文章目录**: `source/_posts/` - 所有 Markdown 文章放这里
- **主题**: Matery (通过 CI 自动安装，不在仓库中存储)
- **部署**: 推送到 main 分支后，GitHub Actions 自动构建并部署到 gh-pages 分支
- **配置**: `_config.yml` 包含博客全局配置，语言设置为 zh-CN

## 文章 Front Matter 格式

```yaml
---
title: 文章标题
date: 2026-03-02 10:00:00
tags: [标签1, 标签2]
categories: 分类
---
```

## 主题自定义

主题通过 CI 从 `https://github.com/blinkfox/hexo-theme-matery` 克隆。如需自定义主题配置，在 `_config.yml` 中添加主题配置或创建 `_config.matery.yml`。

# 我的博客

基于 Hexo + GitHub Pages 搭建的个人博客，支持 **上传 MD 文件自动发布**。

## 🚀 快速开始

### 1. 创建新文章

在 `source/_posts/` 目录下创建 Markdown 文件，文件名格式建议：`年-月-日-标题.md`

```bash
# 方式1: 使用 Hexo 命令创建
npx hexo new "文章标题"

# 方式2: 直接创建 MD 文件（推荐）
# 将你的 MD 文件放到 source/_posts/ 目录即可
```

### 2. 文章格式

```markdown
---
title: 文章标题
date: 2026-03-02 10:00:00
tags: [标签1, 标签2]
categories: 分类
---

# 这里是文章内容

你的 Markdown 内容...
```

### 3. 自动发布

```bash
# 添加所有更改
git add .

# 提交
git commit -m "新增文章：xxx"

# 推送到 GitHub
git push origin main

# 推送后，GitHub Actions 会自动构建并部署到 GitHub Pages
# 大约 1-2 分钟后访问你的博客查看
```

## 📁 目录结构

```
my-blog/
├── source/
│   └── _posts/          # 👈 把你的 MD 文件放这里
│       ├── 文章1.md
│       └── 文章2.md
├── themes/
│   └── next/            # NexT 主题
├── _config.yml          # 博客配置
├── .github/
│   └── workflows/
│       └── deploy.yml   # 👈 自动部署配置
└── package.json
```

## 🛠 常用命令

```bash
# 本地预览
npx hexo server

# 清除缓存
npx hexo clean

# 生成静态文件
npx hexo generate
```

## 📝 支持的 Markdown 语法

- 标题、段落、列表
- 代码块（支持语法高亮）
- 图片：`![描述](图片路径)`
- 链接：`[文字](URL)`
- 表格、引用、分割线
- 数学公式（需配置）
- ... 所有标准 Markdown 语法

## 🔧 配置

修改 `_config.yml` 自定义博客信息：

```yaml
# 博客标题、描述等
title: 我的技术博客
author: 你的名字

# GitHub 部署配置（已配置 GitHub Actions，无需修改）
```

## 🌐 访问地址

你的博客地址：`https://你的用户名.github.io`

---

**提示**：首次部署需要在 GitHub 仓库设置中启用 Pages：
Settings → Pages → Source 选择 `gh-pages` 分支

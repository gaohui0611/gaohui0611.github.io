---
title: 无需公网 IP，用 Cloudflare Tunnel 把本地电脑变成服务器
date: 2026-03-10 19:00:00
tags: [Cloudflare, 内网穿透, 开发工具]
categories: 技术
---

# 无需公网 IP，用 Cloudflare Tunnel 把本地电脑变成服务器

> 当我告诉我的同事"我把本地电脑变成了公网可访问的服务器"时，他的表情大概是这样的：
> 
> 😲 "等等，你是说... 不需要买服务器？不需要配置防火墙？不需要找运营商开通公网 IP？"
> 
> ✅ "是的，而且这一切都是免费的。"

---

## 为什么你需要这个？

### 传统部署的痛

```
作为一个开发者，你是否遇到过这些场景：

场景 1：开发完成，想给客户演示
❌ "等产品部署到服务器再看吧" —— 客户走了

场景 2：在家办公，想访问公司内网
❌ "连 VPN 啊" —— VPN 经常掉线，配置麻烦

场景 3：个人项目，没有预算买服务器
❌ "去买个云服务器吧" —— 一个月几百块，心疼

场景 4：测试 Webhook
❌ "我本地没有公网 IP" —— 无法测试回调
```

**这些问题 Cloudflare Tunnel 全部可以解决！**

---

## 什么是 Cloudflare Tunnel？

### 一句话解释

> Cloudflare Tunnel 是一条加密通道，把你的本地服务通过 Cloudflare 安全地暴露到公网，而**不需要公网 IP**！

### 工作原理（简单版）

```
用户访问                    你的本地电脑
  │                            │
  ├─> https://example.com         │
  │        ↓                   │
  │   Cloudflare DNS           │
  │        ↓                   │
  │   Cloudflare 网络          │
  │        ↓                   │
  │   加密 Tunnel 通道 ←───────┘
  │        ↓
  │   本地服务 (localhost:3000)
  │        ↓
  │   返回网页
  │
  └─> 用户看到网页 ✅
```

---

## 5 分钟快速上手

### 准备工作

```bash
# 1. 确保域名已接入 Cloudflare
#    以 example.com 为例

# 2. 安装 cloudflared
# macOS
brew install cloudflared

# Linux
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

# 3. 验证安装
cloudflared --version
```

### 步骤 1：登录并创建 Tunnel

```bash
# 登录 Cloudflare（会打开浏览器，选择你的域名）
cloudflared tunnel login

# 创建隧道
cloudflared tunnel create my-tunnel

# 输出类似：
# Tunnel credentials written to /root/.cloudflared/xxxx-xxxx-xxxx.json
# UUID: xxxx-xxxx-xxxx

# 记住这个 UUID，后面要用
```

### 步骤 2：配置 Tunnel

```bash
# 创建配置文件
vim ~/.cloudflared/config.yml
```

```yaml
# 填入你的 Tunnel ID
tunnel: xxxx-xxxx-xxxx
credentials-file: /root/.cloudflared/xxxx-xxxx-xxxx.json

# 配置路由规则
ingress:
  # 规则 1：主域名指向本地 3000 端口
  - hostname: example.com
    service: http://localhost:3000
  
  # 规则 2：子域名指向本地 8080 端口
  - hostname: api.example.com
    service: http://localhost:8080
  
  # 默认规则：其他情况返回 404
  - service: http_status:404
```

### 步骤 3：启动 Tunnel

```bash
# 前台运行（测试用）
cloudflared tunnel run my-tunnel

# 后台运行（生产用）
nohup cloudflared tunnel run my-tunnel > /var/log/cloudflared.log 2>&1 &
```

### 步骤 4：验证访问

```
打开浏览器，访问：
├─ https://example.com        → 你的本地网站 (localhost:3000)
└─ https://api.example.com    → 你的本地 API (localhost:8080)
```

**完成！现在你的本地电脑就是一台"服务器"了！**

---

## 支持的功能

| 功能 | 支持 | 说明 |
|------|------|------|
| **完整 HTML 页面** | ✅ | 整个网页转发 |
| **CSS/JS/图片** | ✅ | 静态资源正常转发 |
| **API 路由** | ✅ | /api/* 完整转发 |
| **WebSocket** | ✅ | 实时双向通信 |
| **POST 请求** | ✅ | 表单提交、文件上传 |
| **Cookies** | ✅ | Session 保持 |
| **HTTPS** | ✅ | 自动处理 SSL |

---

## 费用详解

| 功能 | 免费额度 | 付费价格 |
|------|---------|---------|
| **Tunnel** | 无限流量 | 完全免费 ✅ |
| **DNS** | 无限 | 完全免费 ✅ |
| **SSL 证书** | 自动管理 | 完全免费 ✅ |
| **CDN 加速** | 全球 300+ 节点 | 免费层够用 |
| **安全防护** | DDoS 防护、WAF | 免费层够用 |

**结论**：基础使用**完全免费**！

---

## 适合场景

✅ 开发/测试环境  
✅ 演示/展示  
✅ 个人项目/博客  
✅ 远程访问内网服务  
✅ 测试 Webhook 回调  

---

## 参考链接

- [Cloudflare Tunnel 官方文档](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [cloudflared 下载](https://github.com/cloudflare/cloudflared/releases)
- [Cloudflare Zero Trust](https://www.cloudflare.com/zh-cn/zero-trust/)

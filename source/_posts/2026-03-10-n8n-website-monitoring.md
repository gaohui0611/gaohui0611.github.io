---
title: n8n 网站监测与日报生成指南
date: 2026-03-10 19:30:00
tags: [n8n, 自动化, 运维]
categories: 技术
---

# n8n 网站监测与日报生成指南

## 一、n8n 简介

n8n 是一个开源的自动化工作流工具，允许您通过可视化界面创建自动化工作流，连接各种应用程序和服务。本指南将使用 n8n 来监测网站状态并每天生成日报。

## 二、n8n 安装

### 方式 1：Docker 安装（推荐）

```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### 方式 2：npm 安装

```bash
npm install -g n8n
n8n start
```

安装完成后，访问 `http://localhost:5678` 即可打开 n8n 界面。

## 三、创建网站监测工作流

### 1. 工作流概览

我们将创建一个包含以下步骤的工作流：

1. **定时触发**：每天早上自动运行
2. **网站状态检查**：访问需要监测的网站，检查状态
3. **数据处理**：处理监测结果
4. **日报生成**：生成包含监测结果的日报
5. **通知/存储**：发送日报或存储到指定位置

### 2. 具体配置步骤

#### 步骤 1：添加定时触发器

1. 点击 "Add Node" 添加节点
2. 搜索并选择 "Cron" 节点
3. 配置 Cron 表达式，例如每天早上 8 点运行：
   - Seconds: 0
   - Minutes: 0
   - Hours: 8
   - Day of Month: *
   - Month: *
   - Day of Week: *

#### 步骤 2：添加网站状态检查

1. 点击 "Add Node" 添加节点
2. 搜索并选择 "HTTP Request" 节点
3. 配置以下参数：
   - Method: GET
   - URL: 输入您需要监测的网站 URL
   - 其他参数保持默认

#### 步骤 3：添加数据处理

1. 点击 "Add Node" 添加节点
2. 搜索并选择 "Function" 节点
3. 在代码编辑器中输入以下代码：

```javascript
// 处理 HTTP 请求结果
const response = items[0].json;

// 提取网站状态信息
const status = response.status;
const statusText = response.statusText;
const responseTime = response.meta.responseTime;
const url = response.meta.url;

// 生成状态报告
const reportData = {
  date: new Date().toISOString().split('T')[0],
  website: url,
  status: status,
  statusText: statusText,
  responseTime: responseTime,
  timestamp: new Date().toISOString()
};

// 返回处理后的数据
return [{
  json: reportData
}];
```

#### 步骤 4：添加日报生成

1. 点击 "Add Node" 添加节点
2. 搜索并选择 "Function" 节点
3. 在代码编辑器中输入以下代码：

```javascript
// 获取处理后的数据
const data = items[0].json;

// 生成日报内容
const reportContent = `# 网站监测日报\n\n## 监测时间\n${data.timestamp}\n\n## 监测网站\n${data.website}\n\n## 监测结果\n- 状态码: ${data.status}\n- 状态: ${data.statusText}\n- 响应时间: ${data.responseTime}ms\n\n## 状态判断\n${data.status >= 200 && data.status < 300 ? '✅ 网站正常' : '❌ 网站异常'}`;

// 返回日报内容
return [{
  json: {
    report: reportContent,
    filename: `website-monitor-report-${data.date}.md`
  }
}];
```

#### 步骤 5：添加存储或通知

**选项 A：存储到本地文件**

1. 点击 "Add Node" 添加节点
2. 搜索并选择 "Write Binary File" 节点
3. 配置以下参数：
   - File Path: `/path/to/reports/{{$json.filename}}`
   - Data: 点击 "Add Expression" 并输入 `$json.report`

**选项 B：发送邮件**

1. 点击 "Add Node" 添加节点
2. 搜索并选择 "Email" 节点
3. 配置以下参数：
   - To: 输入您的邮箱地址
   - Subject: 网站监测日报 {{$json.date}}
   - Text: 点击 "Add Expression" 并输入 `$json.report`

## 四、工作流配置完成

### 连接节点

将所有节点按照以下顺序连接：

1. Cron → HTTP Request → Function (数据处理) → Function (日报生成) → Write Binary File/Email

### 启用工作流

1. 点击工作流右上角的 "Save" 按钮保存工作流
2. 点击 "Activate" 按钮启用工作流

## 五、扩展功能

### 监测多个网站

1. 在 HTTP Request 节点后添加 "Split In Batches" 节点
2. 配置批量处理参数
3. 为每个网站创建单独的监测流程

### 增加监测指标

1. 修改 HTTP Request 节点，添加更多监测参数
2. 在数据处理节点中添加更多指标，如：
   - 页面加载时间
   - 关键元素检查
   - SSL 证书状态

### 集成其他服务

1. 添加 "Slack" 节点发送通知
2. 添加 "Google Sheets" 节点存储历史数据
3. 添加 "Telegram" 节点发送消息

## 六、故障排除

### 常见问题

1. **HTTP Request 失败**：检查网站 URL 是否正确，网络连接是否正常
2. **定时任务不执行**：检查 Cron 表达式配置是否正确
3. **文件写入失败**：检查文件路径权限是否正确
4. **邮件发送失败**：检查邮件服务器配置是否正确

### 日志查看

1. 在 n8n 界面中，点击 "Executions" 标签页
2. 查看工作流执行历史和详细日志

## 七、示例工作流

以下是一个完整的 n8n 工作流配置示例：

```json
{
  "nodes": [
    {
      "parameters": {
        "cronExpression": "0 0 8 * * *"
      },
      "name": "Cron",
      "type": "n8n-nodes-base.cron",
      "typeVersion": 1,
      "position": [100, 300]
    },
    {
      "parameters": {
        "method": "GET",
        "url": "https://example.com"
      },
      "name": "HTTP Request",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 2,
      "position": [300, 300]
    },
    {
      "parameters": {
        "functionCode": "// 处理 HTTP 请求结果\nconst response = items[0].json;\n\n// 提取网站状态信息\nconst status = response.status;\nconst statusText = response.statusText;\nconst responseTime = response.meta.responseTime;\nconst url = response.meta.url;\n\n// 生成状态报告\nconst reportData = {\n  date: new Date().toISOString().split('T')[0],\n  website: url,\n  status: status,\n  statusText: statusText,\n  responseTime: responseTime,\n  timestamp: new Date().toISOString()\n};\n\n// 返回处理后的数据\nreturn [{
  json: reportData\n}];"
      },
      "name": "Function",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [500, 300]
    },
    {
      "parameters": {
        "functionCode": "// 获取处理后的数据\nconst data = items[0].json;\n\n// 生成日报内容\nconst reportContent = `# 网站监测日报\\n\\n## 监测时间\\n${data.timestamp}\\n\\n## 监测网站\\n${data.website}\\n\\n## 监测结果\\n- 状态码: ${data.status}\\n- 状态: ${data.statusText}\\n- 响应时间: ${data.responseTime}ms\\n\\n## 状态判断\\n${data.status >= 200 && data.status < 300 ? '✅ 网站正常' : '❌ 网站异常'}`;\n\n// 返回日报内容\nreturn [{
  json: {\n    report: reportContent,\n    date: data.date,\n    filename: `website-monitor-report-${data.date}.md`\n  }\n}];"
      },
      "name": "Function1",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [700, 300]
    },
    {
      "parameters": {
        "filePath": "/reports/{{$json.filename}}",
        "dataPropertyName": "report",
        "options": {
          "writeBinaryData": true
        }
      },
      "name": "Write Binary File",
      "type": "n8n-nodes-base.writeBinaryFile",
      "typeVersion": 1,
      "position": [900, 300]
    }
  ],
  "connections": {
    "Cron": {
      "main": [
        [
          {
            "node": "HTTP Request",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "HTTP Request": {
      "main": [
        [
          {
            "node": "Function",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Function": {
      "main": [
        [
          {
            "node": "Function1",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Function1": {
      "main": [
        [
          {
            "node": "Write Binary File",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

## 七、总结

通过本指南，您可以使用 n8n 创建一个自动化工作流，每天早上监测您需要的网站并生成日报。您可以根据实际需求扩展工作流功能，添加更多监测指标和通知方式。

n8n 的可视化界面使得工作流配置变得简单直观，即使没有编程经验的用户也能轻松上手。

希望本指南对您有所帮助！
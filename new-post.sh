#!/bin/bash
# 快速添加博客文章脚本
# 用法: ./new-post.sh "文章标题" [/path/to/existing.md]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSTS_DIR="$SCRIPT_DIR/source/_posts"

# 确保目录存在
mkdir -p "$POSTS_DIR"

if [ -z "$1" ]; then
    echo "用法: $0 \"文章标题\" [/path/to/existing.md]"
    echo "示例: $0 \"Hello World\""
    echo "示例: $0 \"我的笔记\" ~/Documents/note.md"
    exit 1
fi

TITLE="$1"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
FILENAME="${DATE:0:10}-${TITLE}.md"
FILEPATH="$POSTS_DIR/$FILENAME"

# 创建文章头
cat > "$FILEPATH" << EOF
---
title: ${TITLE}
date: ${DATE}
tags: []
categories:
---

# ${TITLE}

EOF

# 如果指定了现有文件，追加内容
if [ -n "$2" ] && [ -f "$2" ]; then
    echo "" >> "$FILEPATH"
    cat "$2" >> "$FILEPATH"
    echo "已导入: $2"
fi

echo "✓ 文章已创建: $FILEPATH"
echo ""
echo "下一步："
echo "1. 编辑文章内容: vim \"$FILEPATH\""
echo "2. 提交并推送:"
echo "   git add ."
echo "   git commit -m \"新增文章: ${TITLE}\""
echo "   git push"

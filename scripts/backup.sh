#!/usr/bin/env bash
# qqfish · 备份 AstrBot 数据（不含表情包大目录）
# 用法: ./scripts/backup.sh [输出目录]
set -uo pipefail
OUT="${1:-$HOME}"
AB_DIR="${AB_DIR:-$HOME/AstrBot}"
STAMP=$(date +%m%d-%H%M)
FILE="$OUT/astrbot-backup-$STAMP.tgz"

[ -d "$AB_DIR/data" ] || { echo "找不到 $AB_DIR/data"; exit 1; }

echo "打包 $AB_DIR/data → $FILE"
tar -czf "$FILE" -C "$AB_DIR" \
  --exclude='data/attachments/*' \
  --exclude='data/plugin_data/meme_manager/packs/*' \
  --exclude='data/data_v4.db-wal' \
  --exclude='data/data_v4.db-shm' \
  data 2>/dev/null

ls -lh "$FILE"
echo "恢复: tar -xzf $FILE -C $AB_DIR"
echo "提醒: key/密码不在 data 里时，单独备份你的 secrets 目录（不要进 git）"

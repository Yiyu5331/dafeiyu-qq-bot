#!/usr/bin/env bash
# qqfish · 重启 AstrBot
# 用法: ./scripts/restart_astrbot.sh [AstrBot目录] [端口]
set -uo pipefail
AB_DIR="${1:-$HOME/AstrBot}"
PORT="${2:-6185}"
LOG="${AB_LOG:-/tmp/astrbot.log}"

cd "$AB_DIR" || { echo "找不到 $AB_DIR"; exit 1; }

echo "停止旧进程…"
pkill -f "AstrBot.*main.py" 2>/dev/null
pkill -f "\.venv/bin/python3 main.py" 2>/dev/null
sleep 2

echo "启动…"
nohup .venv/bin/python3 main.py > "$LOG" 2>&1 &
echo "PID=$!  日志=$LOG"

for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "http://127.0.0.1:${PORT}" || echo 000)
  if [ "$code" = "200" ]; then echo "✅ 后台已就绪 http://127.0.0.1:${PORT}"; exit 0; fi
  sleep 2
done

echo "❌ 30 秒内没起来，看日志:"; tail -30 "$LOG"; exit 1

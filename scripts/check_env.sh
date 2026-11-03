#!/usr/bin/env bash
# qqfish · 环境自检：三个进程 / 两个端口 / 日志报错
# 用法: ./scripts/check_env.sh
set -uo pipefail

AB_PORT="${AB_PORT:-6185}"
WS_PORT="${WS_PORT:-6199}"
AB_LOG="${AB_LOG:-/tmp/astrbot.log}"

ok=0; bad=0
say() { printf "%-28s %s\n" "$1" "$2"; }
pass() { ok=$((ok+1)); say "$1" "✅ $2"; }
fail() { bad=$((bad+1)); say "$1" "❌ $2"; }

echo "=== qqfish 自检 $(date '+%F %T') ==="

# 1. 进程
if pgrep -f "AstrBot|main.py" >/dev/null 2>&1; then pass "AstrBot 进程" "运行中"; else fail "AstrBot 进程" "没在跑"; fi
if pgrep -f "NapCat|napcat" >/dev/null 2>&1; then pass "NapCat 进程" "运行中"; else fail "NapCat 进程" "没在跑"; fi
if pgrep -f "QQ-test|QQ.app" >/dev/null 2>&1; then pass "QQ 进程" "运行中"; else fail "QQ 进程" "没在跑"; fi

# 2. 端口
code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "http://127.0.0.1:${AB_PORT}" || echo 000)
[ "$code" = "200" ] && pass "AstrBot 后台 :${AB_PORT}" "HTTP 200" || fail "AstrBot 后台 :${AB_PORT}" "HTTP ${code}"

if command -v lsof >/dev/null 2>&1; then
  if lsof -nP -iTCP:${WS_PORT} -sTCP:LISTEN >/dev/null 2>&1; then pass "反向 WS :${WS_PORT}" "有人监听"; else fail "反向 WS :${WS_PORT}" "没人监听"; fi
fi

# 3. 最近日志
if [ -f "$AB_LOG" ]; then
  errs=$(grep -icE "error|401|timeout|Traceback" "$AB_LOG" 2>/dev/null || echo 0)
  say "日志错误行数" "$errs"
  [ "$errs" -gt 0 ] && grep -iE "error|401|timeout" "$AB_LOG" | tail -3
else
  say "日志" "找不到 $AB_LOG"
fi

echo "=== 通过 $ok 项，失败 $bad 项 ==="
[ "$bad" -eq 0 ] || echo "排查顺序: docs/09-运维与排障.md 9.3 节"

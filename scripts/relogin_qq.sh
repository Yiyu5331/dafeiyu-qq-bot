#!/usr/bin/env bash
# qqfish · QQ 掉线后免扫码重登
# 用法: ./scripts/relogin_qq.sh <小号QQ号> [QQ副本路径]
set -uo pipefail
QQ_NUM="${1:?用法: relogin_qq.sh <小号QQ号> [QQ副本路径]}"
APP="${2:-/Applications/QQ-test-mas.app}"
BIN="$APP/Contents/MacOS/QQ"

[ -x "$BIN" ] || { echo "找不到可执行文件: $BIN"; echo "macOS 需要先克隆 QQ: cp -R /Applications/QQ.app /Applications/QQ-test-mas.app"; exit 1; }

pkill -f "$BIN" 2>/dev/null
sleep 1
echo "用登录态启动…（-q 免扫码，失效时手机会弹确认）"
nohup "$BIN" --no-sandbox -q "$QQ_NUM" > /tmp/qq_relogin.log 2>&1 &
sleep 8
grep -iE "登录|login|成功|失败" /tmp/qq_relogin.log | tail -5 || tail -10 /tmp/qq_relogin.log

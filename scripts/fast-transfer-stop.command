#!/bin/bash
# AIGC START — 双击：停止 fast-transfer（快传）
cd "$(dirname "$0")/.."
./scripts/stop.sh
echo ""
read -p "按回车键关闭此窗口…"

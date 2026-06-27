#!/bin/bash
# AIGC START — 双击：停止旧实例 → 打包 → 启动 fast-transfer（快传）
cd "$(dirname "$0")/.."
./scripts/enable.sh
echo ""
read -p "按回车键关闭此窗口…"

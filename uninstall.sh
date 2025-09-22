#!/usr/bin/env bash
# ================================================
# @Description  : CubeMage 卸载脚本
# @Version      : 1.0.0
# @Author       : CubeMage <cubemage.com@gmail.com>
# @Date         : 2025-09-23
# @LastEditTime : 2025-09-23
# @LastEditors  : CubeMage
# @Copyright    : Copyright (C) 2025 CubeMage
# @License      : This program is free software under the AGPLv3 license.
# @License-Details: See the LICENSE file for details.
# ================================================
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "Use sudo"; exit 1; }
systemctl stop cubemage-txs.service 2>/dev/null || true
systemctl disable cubemage-txs.service 2>/dev/null || true
systemctl daemon-reload || true
ip link del wg0 2>/dev/null || true
ip link del wg  2>/dev/null || true
rm -f /etc/systemd/system/cubemage-txs.service
rm -f /usr/local/bin/cubemage
echo "Cubemage 已卸载（配置保留在 /etc/cubemage/）。如需彻底删除，请手工移除该目录。"

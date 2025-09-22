#!/usr/bin/env bash
set -euo pipefail

BIN="/usr/local/bin/cubemage"
CFG_DIR="/etc/cubemage"
UNIT_PATH="/etc/systemd/system/cubemage-txs.service"

require_root(){ [[ $EUID -eq 0 ]] || { echo "请使用 sudo 运行 / Use sudo"; exit 1; }; }
have(){ command -v "$1" >/dev/null 2>&1; }

require_root
mkdir -p "$CFG_DIR" && chmod 700 "$CFG_DIR"

# 1) 优先使用当前目录的 cubemage（离线安装）
if [[ -f ./cubemage ]]; then
  install -m 0755 ./cubemage "$BIN"
else
  # 2) 尝试在线下载（准备好仓库后可用）
  REPO_RAW="https://raw.githubusercontent.com/cubemage-com/tuxingsun/main"
  if have curl; then
    curl -fsSL "$REPO_RAW/cubemage" -o "$BIN" || { echo "下载失败：请手动把 cubemage 放到 /usr/local/bin 并赋予可执行权限"; exit 2; }
  elif have wget; then
    wget -qO "$BIN" "$REPO_RAW/cubemage" || { echo "下载失败：请手动把 cubemage 放到 /usr/local/bin 并赋予可执行权限"; exit 2; }
  else
    echo "缺少 curl/wget，且当前目录没有 cubemage 文件。请先安装 curl 或 wget，或将 cubemage 放到当前目录。"; exit 1
  fi
  chmod +x "$BIN"
fi

# 安装 systemd 单元
if [[ -f ./systemd/cubemage-txs.service ]]; then
  install -m 0644 ./systemd/cubemage-txs.service "$UNIT_PATH"
else
  # 兜底写入（不依赖网络）
  cat >"$UNIT_PATH" <<'UNIT'
[Unit]
Description=Cubemage Tuxingsun (WireGuard) service
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/env wg-quick up /etc/cubemage/tuxingsun/active/wg.conf
ExecStop=/usr/bin/env wg-quick down /etc/cubemage/tuxingsun/active/wg.conf
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_RAW
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_RAW
ProtectSystem=full
ProtectHome=true

[Install]
WantedBy=multi-user.target

UNIT
fi

# 默认语言：中文
echo "LANG=zh" > "$CFG_DIR/config"

systemctl daemon-reload || true

echo "✅ 安装完成：/usr/local/bin/cubemage"
echo "   默认语言：中文。可用命令： cubemage --help"

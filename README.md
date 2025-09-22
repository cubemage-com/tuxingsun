# Cubemage Tuxingsun — 多通道 WireGuard 管理工具

## 简介
Cubemage Tuxingsun 是轻量级 WireGuard 管理工具，支持多通道/多客户端/二维码导出，自动设置 NAT/转发（Linux）。默认语言为中文，可 `sudo cubemage lng en` 切换英文。

## 在线安装
```bash
curl -fsSL https://raw.githubusercontent.com/cubemage-com/tuxingsun/main/install.sh -o install.sh && sudo bash install.sh
```
或者
```bash
wget -qO install.sh https://raw.githubusercontent.com/cubemage-com/tuxingsun/main/install.sh && sudo bash install.sh
```

## 离线安装（ZIP 包）
```bash
unzip tuxingsun-main.zip -d cubemage-tuxingsun
cd cubemage-tuxingsun
sudo bash install.sh
```
安装后：`cubemage --help`

## 初始化服务器（新环境）
```bash
sudo cubemage txs init --channel=default --address=10.7.0.1/24 --port=51820 --wan-if=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{print $5;exit}')
```
- `--channel`：通道名；创建后成为当前激活通道
- `--address`：服务端隧道地址（CIDR），如 `10.7.0.1/24`
- `--port`：UDP 监听端口（需放行安全组）
- `--wan-if`：出口网卡名（自动探测失败时指定，如 eth0）

## 通道管理
```bash
sudo cubemage txs channel create corp --address=10.8.0.1/24 --port=51821 --wan-if=eth0
sudo cubemage txs channel update corp --address=10.9.0.1/24 --port=51830 --wan-if=eth0
sudo cubemage txs channel use corp
sudo cubemage txs channel list
sudo cubemage txs channel delete old
```

## 客户端管理
```bash
sudo cubemage txs client create --channel=corp --name=alice --ip=10.8.0.2 --endpoint=txs.example.com --port=51821 --dns=1.1.1.1 --allowed=0.0.0.0/0
cubemage txs client list --channel=corp
cubemage txs client alice config --channel=corp
cubemage txs client alice qrcode --channel=corp
sudo cubemage txs client update --channel=corp --name=alice --ip=10.8.0.22 --dns=8.8.8.8 --allowed=0.0.0.0/0
sudo cubemage txs client delete --channel=corp --name=alice
```
- `--endpoint`：客户端连接使用的服务器域名或 IP（可自动加端口）
- `--dns`：客户端使用 DNS（默认 `1.1.1.1`）
- `--allowed`：客户端路由，默认 `0.0.0.0/0`（全局）

## 服务控制与卸载
```bash
sudo cubemage txs server start|stop|restart|status
sudo cubemage txs stop
sudo cubemage txs uninstall
# 或
sudo bash uninstall.sh
```

## 平台说明与建议
- **Linux**：完整支持（服务端 + NAT/转发）
- **macOS**：仅生成配置（不自动做 NAT）
- **Windows**：推荐作为客户端（WireGuard for Windows 导入配置）

## 法律与安全
- 仅供合法用途；不得用于违法行为
- 使用者自行承担风险与责任


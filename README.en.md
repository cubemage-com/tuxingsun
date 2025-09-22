# Cubemage Tuxingsun — Multi-Channel WireGuard CLI

> Version v0.3.0 · Build 2025-09-21 08:10:57Z

## Online INstall
```bash
curl -fsSL https://raw.githubusercontent.com/cubemage-com/tuxingsun/main/install.sh -o install.sh && sudo bash install.sh
```
或者
```bash
wget -qO install.sh https://raw.githubusercontent.com/cubemage-com/tuxingsun/main/install.sh && sudo bash install.sh
```

## Install (ZIP, offline)
```bash
unzip tuxingsun-main.zip -d cubemage-tuxingsun
cd cubemage-tuxingsun
sudo bash install.sh
```
Then: `cubemage --help`

## Init server
```bash
sudo cubemage txs init --channel=default --address=10.7.0.1/24 --port=51820 --wan-if=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{print $5;exit}')
```

## Channel & Clients
```bash
sudo cubemage txs channel create corp --address=10.8.0.1/24 --port=51821 --wan-if=eth0
sudo cubemage txs client create --channel=corp --name=alice --ip=10.8.0.2 --endpoint=txs.example.com --port=51821
cubemage txs client alice qrcode --channel=corp
```

## Legal
For lawful use only.

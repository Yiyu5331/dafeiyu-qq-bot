# 03 · 装 AstrBot（大脑）

## 3.1 拉源码

```bash
cd ~
git clone https://github.com/AstrBotDevs/AstrBot.git
cd AstrBot
```

## 3.2 装依赖

```bash
uv sync
# 或者
uv run main.py --help
```

第一次会装挺久（100+ 依赖）。如果卡在某个包，换国内镜像：

```bash
uv sync --index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

## 3.3 启动

```bash
cd ~/AstrBot
nohup .venv/bin/python3 main.py > /tmp/astrbot.log 2>&1 &
```

Windows：

```bat
cd /d %USERPROFILE%\AstrBot
start /b .venv\Scripts\python.exe main.py > %TEMP%\astrbot.log 2>&1
```

启动成功的标志（看 `/tmp/astrbot.log`）：

```
[AstrBot] Dashboard 已启动: http://127.0.0.1:6185
```

## 3.4 进后台

浏览器打开 `http://127.0.0.1:6185`

默认账号密码：`astrbot` / `astrbot`

**第一件事就是改密码**，见文档 08。

## 3.5 后台里有什么

| 页面 | 用途 |
|---|---|
| 控制台 | 实时消息、日志 |
| 平台适配器 | 配 QQ 连接（文档 04） |
| 服务提供商 | 配 DeepSeek / 豆包 / 硅基流动（文档 05） |
| 人格 | 配人格（文档 06） |
| 插件 | 表情包、记忆、语音等 |
| 设置 | 管理员、白名单、浅色深色 |

## 3.6 配置文件在哪

大部分后台能改的东西，最终都写进：

```
~/AstrBot/data/cmd_config.json
```

想批量改、或者备份，直接动这个文件（改完重启生效）。

> 后台改配置偶尔会覆盖手改的内容，改之前先 `cp cmd_config.json cmd_config.json.bak`。

## 3.7 常用命令

```bash
# 重启
pkill -f "AstrBot/main.py"; sleep 1
cd ~/AstrBot && nohup .venv/bin/python3 main.py > /tmp/astrbot.log 2>&1 &

# 看日志
tail -f /tmp/astrbot.log

# 看进程
ps aux | grep main.py | grep -v grep
```

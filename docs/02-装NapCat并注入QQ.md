# 02 · 装 NapCat 并注入 QQ（最容易卡住的一步）

## 2.1 为什么需要它

QQNT 是个 Electron 应用。程序想「代替人收发消息」，有两条路：

1. 用官方机器人接口 —— 小号根本开不了，而且限制极多
2. **把代码注入进 QQ 进程**，骗它「我是你的一部分」

NapCat 走的是第 2 条。它把自己挂进 QQNT，然后在本地开一个 WebSocket，让 AstrBot 能收发消息。

代价是：**QQ 一更新，注入就可能失效**。

## 2.2 为什么必须「克隆一份 QQ」

macOS 上如果你直接在 `/Applications/QQ.app` 注入，会失败或者白屏，原因是：

- App Store 版 QQ 带路径校验，签名里写着安装路径
- 注入会修改可执行文件，签名就废了，Gatekeeper 直接拦

**做法：把整个 App 复制一份，改名，注入副本。**

```bash
cp -R /Applications/QQ.app /Applications/QQ-test-mas.app
```

> 名字随便，但别叫 `QQ.app`。之后所有启动、注入、重登都用这个副本。

Windows 不需要克隆，但需要管理员权限。

## 2.3 装 NapCat

1. 去 NapCat 的 release 页面下载 `NapCat.Shell`（或者 `NapCat.Framework`）
2. 解压到一个固定目录，比如 `~/napcat`
3. 里面应该有：`napcat.mjs`、`config/`、启动脚本

macOS / Linux：

```bash
cd ~/napcat
./napcat.sh          # 或者 node napcat.mjs
```

Windows：双击 `NapCatWinBootMain.exe`（或 `.bat`）——它会去找 QQ 并注入。

## 2.4 第一次启动：拿二维码

启动后有两种看二维码的方式：

- **NapCat WebUI**：浏览器打开 `http://127.0.0.1:6099`，用 `webui.json` 里的 token 登录
- **日志**：终端里直接打印二维码（有些版本是 ASCII 二维码）

`webui.json` 大概长这样（在 `~/Library/Application Support/QQ/NapCat/` 或 `~/napcat/config/`）：

```json
{ "host": "127.0.0.1", "port": 6099, "token": "一串随机字符" }
```

> token 保留，后面连 AstrBot 还要用（不是同一个 token，别搞混）。

## 2.5 扫码登录小号

**这一步必须你本人操作**，我把二维码给你，你用小号的手机 QQ 扫。

扫完之后：

- 电脑上的 QQ 界面会进入已登录状态
- NapCat 日志出现 `登录成功` / `account online`
- WebUI 里能看到账号信息

## 2.6 掉线了怎么免扫码重登

QQ 会时不时掉线（换网络、被踢、休眠）。重新扫码很烦，所以留一条命令：

```bash
/Applications/QQ-test-mas.app/Contents/MacOS/QQ --no-sandbox -q <小号QQ号>
```

- `-q` 后面直接给账号，会读本地缓存的登录态，**大多数情况不用扫码**
- 如果它还是要扫码，那就是登录态失效了，只能再扫一次

Windows：

```bat
"C:\Program Files\Tencent\QQNT\QQ.exe" -q <小号QQ号>
```

## 2.7 这一段踩过的坑

| 现象 | 原因 | 解法 |
|---|---|---|
| 解压报「磁盘已满」 | 其实是文件数/解压工具问题，不是真满 | 换解压工具，或用 `ditto` / 7z |
| 注入后 QQ 白屏 | 注入的路径不对，或版本不匹配 | 用克隆出来的 App；确认 NapCat 版本支持当前 QQ |
| 日志 `Worker进程意外退出` | QQ 被系统杀 / 掉线 | 用 2.6 的命令重登 |
| 扫码后立刻又掉 | 本地登录态坏了 | 退出 QQ、删缓存、重扫 |
| Windows 注入失败 | 没管理员权限 | 右键「以管理员身份运行」 |

## 2.8 验证

登录成功后，先在 NapCat WebUI 里确认：

- 账号在线
- 「网络配置」里还没有任何连接（还没接 AstrBot）

然后进入文档 03。

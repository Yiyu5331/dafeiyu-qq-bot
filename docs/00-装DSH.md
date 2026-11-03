# 00 · 先装 DSH（DeepSeek Harness）

这一章从**一张白纸的电脑**开始。装完 DSH，后面的所有事都可以让它替你做——你只需要在**扫码**和**点系统确认框**的时候接手。

> 为什么把 DSH 放第一章：后面 9 章里有 200 多条命令、十几个配置文件、七八次「装依赖」。这些让 AI 来做，比你自己敲快 10 倍，而且它不会抄错端口号。

---

## 0.1 DSH 是什么

DSH（DeepSeek Harness）是 DeepSeek 的**桌面 Agent 客户端**：

- 一个桌面 App（Electron），双击就能开，不需要命令行
- 打开后是一个**本地网页界面**（地址形如 `http://127.0.0.1:51999`），所有对话、文件、任务都在这个界面里
- 它能在**你这台电脑上真的执行命令**：装软件、改配置、起服务、跑脚本、读日志
- 它有「工作区」的概念：你给它一个目录，它就在这个目录里干活

一句话：**它是一个住在本地的、能动手的 AI**。

后面那些脏活它都能干：`git clone`、`uv sync`、改 `cmd_config.json`、查端口、读日志、重启进程。

---

## 0.2 下载

### 方式 A：官网（推荐给第一次装的人）

1. 打开 <https://www.deepseek.com/>
2. 找到「下载」/「Desktop」入口，选 **macOS (Apple Silicon)** 或 **Windows**
3. 下载得到：
   - macOS：`deepseek-harness-x.y.z-mac-arm64.zip`（或 `.dmg`）
   - Windows：`.exe` 安装包

### 方式 B：直连下载（知道自己在干什么时）

DSH 的自动更新走的是 electron-updater，feed 是公开的。可以先用它**查出当前版本的真实下载地址**，再下：

```bash
# 1) 看 macOS Apple Silicon 的当前版本
curl -s https://download.deepseek.com/dsh-desk/feeds/mac-arm64/nightly-mac.yml

# 2) 看 Intel Mac
curl -s https://download.deepseek.com/dsh-desk/feeds/mac-x64/nightly-mac.yml
```

返回大概长这样：

```yaml
version: 0.2.1-rc.5
files:
  - url: >-
      https://download.deepseek.com/dsh-desk/bin/mac-arm64/deepseek-harness-0.2.1-rc.5-mac-arm64.zip
    size: 347767892
```

那个 `url` 就是安装包直链，`size` 是字节数（可以用来核对有没有下完）。

> 我本机跑的是 **0.2.1-rc.5**（`CFBundleShortVersionString`），`/Applications/DeepSeek Harness.app`，包体约 350 MB。版本号会变，方法不会变。

---

## 0.3 安装

### macOS

1. 解压 zip（双击，或者 `ditto -x -k 包.zip /Applications`），得到 `DeepSeek Harness.app`
2. **拖进 `/Applications`**（不要留在下载文件夹里跑，后面它要调系统能力，路径固定更省事）
3. 第一次打开：右键 →「打开」，或者系统设置 → 隐私与安全性 →「仍要打开」

如果提示「**已损坏，无法打开**」或「无法验证开发者」，是隔离属性（quarantine）没清：

```bash
xattr -dr com.apple.quarantine "/Applications/DeepSeek Harness.app"
```

再打开就正常了。这是 macOS 对**所有**非 App Store 应用的标准流程，不是 DSH 有问题。

### Windows

1. 双击 `.exe`，一路下一步
2. 如果 SmartScreen 拦：点「更多信息」→「仍要运行」
3. 装完桌面上会有快捷方式

---

## 0.4 第一次打开：四件事要配

打开后是一个网页界面（Electron 里的 WebView）。第一次用，按顺序做这四件：

### ① 登录 / 填 API key

DSH 要一个模型来当「脑子」。两种方式：

- **登录 DeepSeek 账号**：界面里点登录，走网页授权
- **填 API key**：在设置里贴一个 `sk-` 开头的 key（从 <https://platform.deepseek.com/> 的「API keys」页面建）

> 这里填的 key 是**给 DSH 自己用的**，和后面 QQ bot 用的 key 是两回事。可以同一个 key，也可以分开，建议分开——好算账。

### ② 选工作区（很重要）

DSH 会问你「在哪个目录工作」。**一定要选一个你找得到的空目录**，比如：

```
/Users/你的用户名/Desktop/qqfish-workspace     # macOS
D:\qqfish-workspace                             # Windows
```

原因：后面所有生成的配置文件、日志、备份、仓库都落在这个目录里。选错了，你会找不到东西。

### ③ 选权限模式

DSH 有几种文件权限模式，装这套东西建议：

| 模式 | 能做什么 | 什么时候用 |
|---|---|---|
| `read-only` | 只能读 | 只想让它看看的时候 |
| `workspace-write` | 只能改工作区内的文件 | **默认，够用** |
| `danger-full-access` | 能改全盘、装系统级软件 | 装 App、注入 QQ 这类必须提权的时候 |

装 NapCat 注入 QQ、写 `/Applications` 的时候需要 `danger-full-access`；平时聊聊天用 `workspace-write` 就行。

### ④ 审批提示

默认情况下，DSH 做**危险动作**（删文件、装系统软件、改系统设置）会先问你一句「要不要执行」。看到这种提示：

- 看清楚它要做什么
- 是这一步该做的事 → 点允许
- 不认识 → 先问它「你要做什么，为什么要这么做」

> 这套教程里，会出现提示的地方只有几处：装 uv / 装 Node / 克隆 QQ / 注入 QQ / 安装依赖。都是正常的。

---

## 0.5 装完先验证一下

在 DSH 的对话框里输入：

```
你现在的工作目录是哪里？这台电脑是什么系统、什么架构？有没有装 python3、node、ffmpeg、uv？
```

它应该回：

- 工作目录 = 你刚才选的那个目录
- 系统 = macOS（或 Windows）/ arm64（或 x64）
- 列表里哪些有、哪些没有

**这一步不是形式**：后面每一章都要看它能不能执行命令、能不能读文件。如果它连 `pwd` 都跑不了，说明权限或工作区没配好，先解决这个再往下。

---

## 0.6 把任务交给它

验证通过后，直接把这句发给它：

> 克隆 https://github.com/Yiyu5331/dafeiyu-qq-bot ，读 docs/ 里的教程，按 00 → 10 的顺序把 QQ 机器人装好。遇到要扫码、要我在手机上确认、或者系统弹窗的时候，停下来叫我。所有 key、密码自己读自己写，不要打印出来。

然后你就去干别的，它会在需要你的时候叫你。

---

## 0.7 常见问题

| 现象 | 原因 | 解决 |
|---|---|---|
| 打开白屏 | 端口被占 / 上次进程没退干净 | 退出 App 重开；`lsof -i :51999` 看谁占着 |
| 「已损坏，无法打开」 | quarantine 属性 | `xattr -dr com.apple.quarantine "/Applications/DeepSeek Harness.app"` |
| 界面能开但模型不回复 | 没登录 / key 无效 / 欠费 | 设置里重新登录或换 key，去 platform.deepseek.com 看余额 |
| 让它跑命令报「没有权限」 | 权限模式是 `read-only` | 切到 `workspace-write` 或 `danger-full-access` |
| 找不到工作区 | 当初选了个临时目录 | 重新选一个固定目录，把文件搬过去 |
| 下载很慢 | 网络 | 换网络 / 挂代理；DSH 本体 350 MB，慢是正常的 |

---

## 0.8 这一章结束时你手上应该有

- [ ] `/Applications/DeepSeek Harness.app`（或 Windows 安装完成）
- [ ] 能打开 DSH 界面，能对话
- [ ] 有一个明确的**工作区目录**记在小本本上
- [ ] 权限模式知道怎么切
- [ ] 发过一句「你现在的工作目录是哪里」，它答对了

齐了就可以进 [01-环境与目录.md](01-环境与目录.md)。

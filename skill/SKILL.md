---
name: qqfish
description: 在一台电脑上用 AstrBot + NapCat 养一个住在 QQ 里的 AI 聊天号（人格、语音、长期记忆、表情包、安全白名单）。当用户说「养一个 QQ 机器人」「让 AI 用 QQ 跟我聊天」「AstrBot + NapCat」「QQ 小号做 AI」「给 AI 一个 QQ 号」时使用。
---

# qqfish · 养一只住在 QQ 里的 AI

这是一套**已经在真机上跑通**的安装流程。你的任务是替用户把机器装好，并在**扫码 / 系统弹窗**这两处停下来叫人。

## 你要先搞清楚的三件事

1. 目标系统是 macOS 还是 Windows（macOS 要克隆 QQ 副本，Windows 不用）
2. 用户要哪个 QQ 号当 bot（**小号**，不是主号）
3. 三把 key 有没有：DeepSeek、火山豆包（语音）、硅基流动（记忆）

## 执行顺序（不要跳步）

| 步 | 做什么 | 读哪一节 | 需要人 |
|---|---|---|---|
| 0 | 装 DSH（DeepSeek Harness）并选好工作区 | `docs/00` | 下载 / 点确认 |
| 1 | 装 Python / uv / Node / ffmpeg | `docs/01` | 否 |
| 2 | 克隆 QQ 副本、注入 NapCat、扫码登录 | `docs/02` | **要扫码** |
| 3 | 装 AstrBot 并起后台 | `docs/03` | 否 |
| 4 | 配反向 WebSocket + token，验证连接 | `docs/04` | 否 |
| 5 | 配三个 provider（DeepSeek / 豆包 / 硅基流动） | `docs/05` | 申请 key 要人 |
| 6 | 写人格（可先用 `configs/persona.example.md`） | `docs/06` | 否 |
| 7 | 装表情包 / 语音 / 记忆插件 | `docs/07` | 否 |
| 8 | 安全护栏（白名单 / 管理员 / 关电脑操作） | `docs/08` | 否 |
| 9 | 自检 | `scripts/check_env.sh` + `docs/09` | 否 |

照抄命令在 `docs/11-逐条命令清单.md`，每一步都写了「成功是什么样」。

## 硬性规则

- **任何 key、密码都不要打印到对话里**，也不要写进仓库；只写进用户指定的本地文件
- **白名单格式**：`qq:FriendMessage:<QQ号>`，群聊是 `qq:GroupMessage:<群号>`；少一段就匹配不上
- **`computer_use_runtime` 必须保持 `none`**，除非用户明确要求并理解风险
- **扫码 / 系统安全弹窗 / QQ 登录确认**：停下来，告诉用户「现在需要你扫一下」，等他说好了再继续
- 改 `cmd_config.json` 后必须重启 AstrBot 才生效
- 表情包目录几百 MB，备份要排除，别打进 git

## 自检命令

```bash
./scripts/check_env.sh
```

期望：三个进程 ✅、后台 200、6199 有人监听。不全绿就按 `docs/09` 9.3 节五步查。

## 装完之后

把 `docs/10` 交给用户看。一句话总结：**它不是配置，是养**——人格要改、语音要开、记忆要看有没有真的记住。

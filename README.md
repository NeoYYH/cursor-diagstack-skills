# Cursor DiagStack Skills

PK2C / Traveo II 诊断栈（DiagStack）相关的 [Cursor Agent Skills](https://cursor.com/docs/skills) 集合。

## 调用方式（全局 · 不区分大小写）

| 写法 | 效果 |
|------|------|
| **`@ass`** | 加载 skill（推荐，目录/name 均为小写） |
| **`ASS`** / **`ass`** / **`A`** | 对话里点名即可 |
| **`@ASS`** / **`/ASS`** | 一般也可（大小写不敏感时） |

行为：**先加齐 DiagStack 注释，再按 MISRA C 改码**。

> **重要**：Cursor 要求 skill **文件夹名小写**。必须是 `ass/`，不能是 `ASS/`，否则 `@ASS` 会提示找不到 Skill。

## 为什么另一个窗口找不到？

Cloud Agent 装到的是云端机器的 `~/.cursor/skills`，**不会**自动出现在你 Windows 本机。  
必须在本机安装到：

- `%USERPROFILE%\.cursor\skills\ass\SKILL.md`
- `%USERPROFILE%\.agents\skills\ass\SKILL.md`（双保险）

然后**完全退出并重启 Cursor**，再开**新对话**用 `@ass`。

## 本机一键安装（推荐，无需克隆）

PowerShell（安装合并进 `main` 之后）：

```powershell
irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex
```

若该修复 PR 尚未合入 main，先用分支：

```powershell
irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/cursor/fix-ass-skill-install-d292/scripts/install-from-github.ps1 | iex
```

或指定 Ref：

```powershell
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/cursor/fix-ass-skill-install-d292/scripts/install-from-github.ps1))) -Ref cursor/fix-ass-skill-install-d292
```

装完自检：

```powershell
dir $env:USERPROFILE\.cursor\skills\ass\SKILL.md
dir $env:USERPROFILE\.agents\skills\ass\SKILL.md
```

两个路径都应存在 `SKILL.md`。然后关掉 Cursor 再开。

## 从仓库安装

```powershell
git clone https://github.com/NeoYYH/cursor-diagstack-skills.git
cd cursor-diagstack-skills
git pull
.\scripts\install.ps1
```

## 仓库结构

```
cursor-diagstack-skills/
├── README.md
├── LICENSE
├── skills/
│   └── ass/                   # 必须小写
│       ├── SKILL.md
│       └── examples.md
└── scripts/
    ├── install.ps1
    ├── install.sh
    └── install-from-github.ps1
```

## 使用示例

- 「@ass 给 secc_add_tim.c 加注释并按 MISRA 改」
- 「ASS：处理 Boot1/Core 下所有程序」
- 「A：按规范修这个文件」

## Skill 列表

| Skill | 说明 |
|-------|------|
| [ass](skills/ass/SKILL.md) | DiagStack 注释 + MISRA（调用：`@ass` / `ASS` / `A`） |

> 旧名 `ASS/`（大写目录）、`dsc-a` / `dsc-b` / `diagstack-c-comment-style` 已废弃；安装脚本会清理。

## License

MIT — 见 [LICENSE](LICENSE)

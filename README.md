# Cursor DiagStack Skills

PK2C / Traveo II 诊断栈（DiagStack）相关的 [Cursor Agent Skills](https://cursor.com/docs/skills) 集合。

## 调用方式（全局 · 不区分大小写）

| 写法 | 效果 |
|------|------|
| **`@ass`** | 加载 skill（推荐） |
| **`ASS`** / **`ass`** / **`A`** | 对话里点名即可 |

行为：**先加齐 DiagStack 注释，再按 MISRA C 改码**。

默认作者是 **YYH**，写在 [skills/ass/AUTHOR](skills/ass/AUTHOR)。没改过就用这个名字。

改名并同步到云端和本机：把 `AUTHOR` 改成一行新名字，然后在**云端机器**和**本机**各跑一次安装。脚本会把同一份写到 Cursor 扫描的两个目录：

- `%USERPROFILE%\.cursor\skills\ass\AUTHOR`
- `%USERPROFILE%\.agents\skills\ass\AUTHOR`

当次对话写 `作者 ZS` 只影响这一轮。只影响当前工程时，在工程根目录放 `.ass-author`。对照见 [skills/ass/examples.md](skills/ass/examples.md) 的「作者名示例」。

已有代码但原来没有注释时：修订记录第一行是 `V1.0  未知  未知  初始发布版本`，补注释的人（默认 `YYH`）只出现在下一行。

> Skill 目录必须是小写 **`ass/`**（Windows 上 `ASS` 与 `ass` 是同一路径，勿再建大写目录）。

## 本机安装（Windows · 已验证）

在 **本机 PowerShell** 执行（不要依赖 Cloud Agent 云端目录）：

```powershell
$ErrorActionPreference = "Stop"
$base = "https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/skills/ass"
foreach ($root in @(
  "$env:USERPROFILE\.cursor\skills",
  "$env:USERPROFILE\.agents\skills"
)) {
  $dst = Join-Path $root "ass"
  New-Item -ItemType Directory -Force -Path $root | Out-Null
  if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  Invoke-WebRequest "$base/SKILL.md" -OutFile "$dst\SKILL.md" -UseBasicParsing
  Invoke-WebRequest "$base/examples.md" -OutFile "$dst\examples.md" -UseBasicParsing
  Invoke-WebRequest "$base/AUTHOR" -OutFile "$dst\AUTHOR" -UseBasicParsing
  Write-Host "Installed: $dst"
}
dir $env:USERPROFILE\.cursor\skills\ass\SKILL.md
dir $env:USERPROFILE\.agents\skills\ass\SKILL.md
```

若 `main` 上还没有 `skills/ass`（PR 未合入），把上面的 `$base` 换成：

```powershell
$base = "https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/cursor/ass-author-revision-70e2/skills/ass"
```

自检两个路径都有 `SKILL.md` 后：**完全退出 Cursor → 再开 → 新对话 → `@ass`**。

### 一键脚本（可选）

```powershell
irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex
```

注意：Windows 下清理遗留大写 `ASS` 时不能误删目标 `ass`（脚本已处理大小写同路径）。

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
│       ├── examples.md
│       └── AUTHOR                 # 默认 YYH，一行
└── scripts/
    ├── install.ps1
    ├── install.sh
    └── install-from-github.ps1
```

## 常见问题

| 现象 | 原因 | 处理 |
|------|------|------|
| `@ASS` / `@ass` 找不到 Skill | 只装在云端，本机没有 | 用上方 PowerShell 装到 `%USERPROFILE%\.cursor\skills\ass` |
| `Removed legacy: ...\ASS` 后下载失败 | Windows 上 ASS=ass，删遗留时连目标一起删了 | 用已修复脚本，或用上方「已验证」粘贴安装 |
| 装完仍看不到 | 未重启 / 未新开对话 | 完全退出 Cursor 后再开新 chat |
| 作者不是想要的名字 | 仍是默认 `YYH`，或云端/本机 `AUTHOR` 不一致 | 改 `skills/ass/AUTHOR` 后，云端和本机都重装；或当次说 `作者 ZS` |
| 旧文件初始版本作者变成补注释的人 | 原先没有文件头 | 初始行作者保持 `未知`，本次另记 `V1.1` |

## Skill 列表

| Skill | 说明 |
|-------|------|
| [ass](skills/ass/SKILL.md) | DiagStack 注释 + MISRA（`@ass` / `ASS` / `A`） |

> 旧名 `ASS/`、`dsc-a` / `dsc-b` / `diagstack-c-comment-style` 已废弃。

## License

MIT — 见 [LICENSE](LICENSE)

# Cursor DiagStack Skills

PK2C / Traveo II 诊断栈（DiagStack）相关的 [Cursor Agent Skills](https://cursor.com/docs/skills) 集合。

## 调用方式（全局 · 不区分大小写）

| 写法 | 效果 |
|------|------|
| **`@art`** / **`/art`** | 加载 skill。只加注释，不改函数名 |
| **`@ArtStd`** / **`/ArtStd`** | 加注释，并按 AUTOSAR Classic 改公开函数名 |
| **`@artstd`** / **`/artstd`** / **`@art_std`** / **`/art_std`** | 与 `@ArtStd` 相同。大小写不限 |

没有 `@` 或 `/` 的 `ArtStd` 不触发。`@ArtStd` 对应技能目录 `artstd/`，`@art_std` 对应 `art_std/`。

行为：**先加齐 DiagStack 注释，再按 MISRA C 改码**。

默认作者是 **YYH**，写在 [skills/art/AUTHOR](skills/art/AUTHOR)。没改过就用这个名字。

改名并同步到云端和本机：把 `AUTHOR` 改成一行新名字，然后在**云端机器**和**本机**各跑一次安装。脚本会把同一份写到 Cursor 扫描的两个目录：

- `%USERPROFILE%\.cursor\skills\art\AUTHOR`
- `%USERPROFILE%\.agents\skills\art\AUTHOR`

当次对话写 `作者 ZS` 只影响这一轮。只影响当前工程时，在工程根目录放 `.art-author`。对照见 [skills/art/examples.md](skills/art/examples.md) 的「作者名示例」。

已有代码但原来没有注释时：修订记录第一行是 `V1.0  未知  未知  初始发布版本`，补注释的人（默认 `YYH`）只出现在下一行。

公开函数的 AUTOSAR Classic 名字是模块前缀加下划线，每个单词首字母大写，例如 `Adc_ReadTask`。只说 `@art` 不改原函数名。写代码并套用本标准时，新公开函数用这个名字。已有函数也要改名时用 **`@ArtStd`** 或 **`/ArtStd`**。

有含义的数字改成模块前缀宏，例如 `ADC_SAMPLE_TIMEOUT_MS`。`0U` 和 `1U` 不包成宏。

> Skill 目录必须是小写 **`art/`**（Windows 上 `ART` 与 `art` 是同一路径，勿再建大写目录）。

## 本机安装（Windows · 已验证）

在 **本机 PowerShell** 执行（不要依赖 Cloud Agent 云端目录）：

```powershell
$ErrorActionPreference = "Stop"
$base = "https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/skills/art"
foreach ($root in @(
  "$env:USERPROFILE\.cursor\skills",
  "$env:USERPROFILE\.agents\skills"
)) {
  $dst = Join-Path $root "art"
  New-Item -ItemType Directory -Force -Path $root | Out-Null
  $old = Join-Path $root "ass"
  if (Test-Path $old) { Remove-Item -Recurse -Force $old }
  if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  Invoke-WebRequest "$base/SKILL.md" -OutFile "$dst\SKILL.md" -UseBasicParsing
  Invoke-WebRequest "$base/examples.md" -OutFile "$dst\examples.md" -UseBasicParsing
  Invoke-WebRequest "$base/AUTHOR" -OutFile "$dst\AUTHOR" -UseBasicParsing
  Write-Host "Installed: $dst"
  $skillsRoot = $base.Substring(0, $base.LastIndexOf("/"))
  foreach ($name in @("artstd", "art_std")) {
    $alias = Join-Path $root $name
    if (Test-Path $alias) { Remove-Item -Recurse -Force $alias }
    New-Item -ItemType Directory -Force -Path $alias | Out-Null
    Invoke-WebRequest "$skillsRoot/$name/SKILL.md" -OutFile "$alias\SKILL.md" -UseBasicParsing
    Write-Host "Installed: $alias"
  }
}
dir $env:USERPROFILE\.cursor\skills\art\SKILL.md
dir $env:USERPROFILE\.cursor\skills\artstd\SKILL.md
dir $env:USERPROFILE\.cursor\skills\art_std\SKILL.md
```

若 `main` 上还没有 `skills/art`（PR 未合入），把上面的 `$base` 换成：

```powershell
$base = "https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/cursor/ass-author-revision-70e2/skills/art"
```

自检 `art`、`artstd`、`art_std` 都有 `SKILL.md` 后：**完全退出 Cursor → 再开 → 新对话 → `@art` 或 `/art`**。改公开函数名用 `@ArtStd` 或 `/ArtStd`。

### 一键脚本（可选）

```powershell
irm https://raw.githubusercontent.com/NeoYYH/cursor-diagstack-skills/main/scripts/install-from-github.ps1 | iex
```

注意：Windows 下清理遗留大写 `ART` 时不能误删目标 `art`（脚本已处理大小写同路径）。

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
│   ├── art/                   # 必须小写。@art / /art
│   │   ├── SKILL.md
│   │   ├── examples.md
│   │   └── AUTHOR             # 默认 YYH，一行
│   ├── artstd/                # @ArtStd / /ArtStd
│   │   └── SKILL.md
│   └── art_std/               # @art_std / /art_std
│       └── SKILL.md
└── scripts/
    ├── install.ps1
    ├── install.sh
    └── install-from-github.ps1
```

## 常见问题

| 现象 | 原因 | 处理 |
|------|------|------|
| `@ART` / `@art` 找不到 Skill | 只装在云端，本机没有 | 用上方 PowerShell 装到 `%USERPROFILE%\.cursor\skills\art` |
| `Removed legacy: ...\ART` 后下载失败 | Windows 上 ART=art，删遗留时连目标一起删了 | 用已修复脚本，或用上方「已验证」粘贴安装 |
| 装完仍看不到 | 未重启 / 未新开对话 | 完全退出 Cursor 后再开新 chat |
| 作者不是想要的名字 | 仍是默认 `YYH`，或云端/本机 `AUTHOR` 不一致 | 改 `skills/art/AUTHOR` 后，云端和本机都重装；或当次说 `作者 ZS` |
| 旧文件初始版本作者变成补注释的人 | 原先没有文件头 | 初始行作者保持 `未知`，本次另记 `V1.1` |
| 只补注释却改了函数名 | 把 MISRA 或注释当成了重命名 | 只加注释用 `@art`；要改已有函数名用 `@ArtStd` 或 `/ArtStd` |

## Skill 列表

| Skill | 说明 |
|-------|------|
| [art](skills/art/SKILL.md) | DiagStack 注释 + MISRA（`@art` / `/art`） |
| [artstd](skills/artstd/SKILL.md) | 同上，并改公开函数名（`@ArtStd` / `/ArtStd`） |
| [art_std](skills/art_std/SKILL.md) | 与 `artstd` 相同（`@art_std` / `/art_std`） |

> 旧名 `ass` / `ASS` / `A`、`dsc-a` / `dsc-b` / `diagstack-c-comment-style` 已废弃。安装时会删掉旧的 `ass` 目录。

## License

MIT — 见 [LICENSE](LICENSE)

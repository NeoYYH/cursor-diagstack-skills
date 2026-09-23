# Cursor DiagStack Skills

PK2C / Traveo II 诊断栈（DiagStack）相关的 [Cursor Agent Skills](https://cursor.com/docs/agent/skills) 集合。

## 调用方式（全局 · 不区分大小写）

任意项目对话中：

| 写法 | 效果 |
|------|------|
| **`@ASS`** | 加载 skill |
| **`/ASS`** | 加载 skill |
| **`ASS`** / **`ass`** | 加载 skill |
| **`A`** | 同上（短别名） |

行为：**先加齐 DiagStack 注释，再按 MISRA C 改码**（已无单独「只注释」款）。

注释规范：`.h` 简写 Service Name；`.c` 完整（含 Arguments / Return Value）；复杂函数体内必写 `a.` / `1.` 步骤注释。

## 仓库结构

```
cursor-diagstack-skills/
├── README.md
├── LICENSE
├── skills/
│   └── ASS/                   # 注释 + MISRA 改码
│       ├── SKILL.md
│       └── examples.md
└── scripts/
    ├── install.ps1            # Windows → %USERPROFILE%\.cursor\skills\ASS
    └── install.sh             # macOS/Linux → ~/.cursor/skills/ASS
```

## 发布到 GitHub（维护者）

本地仓库路径：`cursor-diagstack-skills/`（与 FirstBoot 工程同级目录）

**前提**：已安装 [GitHub CLI](https://cli.github.com/) 并完成登录：

```powershell
gh auth login -h github.com -p https -w
```

**一键创建远程仓库并推送：**

```powershell
cd cursor-diagstack-skills
.\scripts\publish.ps1
```

可选参数：`-RepoName`、`-Visibility private`、`-Description "..."`

**手动方式：**

```powershell
cd cursor-diagstack-skills
git branch -M main
gh repo create cursor-diagstack-skills --public --source=. --remote=origin --push
```

创建成功后，仓库地址：https://github.com/NeoYYH/cursor-diagstack-skills

## 本地挂载（全局安装，所有工程可用）

### Windows (PowerShell)

```powershell
git clone https://github.com/NeoYYH/cursor-diagstack-skills.git
cd cursor-diagstack-skills
git pull
.\scripts\install.ps1
```

若已有本地克隆，只需：

```powershell
cd <你的>\cursor-diagstack-skills
git pull
.\scripts\install.ps1
```

安装目标：`%USERPROFILE%\.cursor\skills\ASS\`

### macOS / Linux

```bash
git clone https://github.com/NeoYYH/cursor-diagstack-skills.git
cd cursor-diagstack-skills
git pull
chmod +x scripts/install.sh
./scripts/install.sh
```

安装目标：`~/.cursor/skills/ASS/`

安装后**重启 Cursor** 或开新对话，即可在任意项目使用 `@ASS` / `/ASS` / `A`。

### 仅当前项目（可选）

```
your-project/.cursor/skills/ASS/
```

## 使用示例

- 「@ASS 给 `tviibe1m/src/Boot1/Core` 下所有程序加注释并按 MISRA 改」
- 「/ASS 处理这个 FinishStep」
- 「A：按规范修 Boot1_Download.c」

Agent 会：

1. 写文件头 / 英文分区 / Service Name 块
2. 复杂函数体内补 `a.` / `1.` 步骤注释
3. 按 MISRA：Yoda 比较、强制大括号、`0U` 后缀、`(void)` 丢弃返回值、`default` 等改码

## Skill 列表

| Skill | 说明 |
|-------|------|
| [ASS](skills/ASS/SKILL.md) | DiagStack 注释 + MISRA C 改码（调用：`@ASS` / `/ASS` / `A`） |

> 旧名 `dsc-a` / `dsc-b` / `diagstack-c-comment-style` 已废弃；安装脚本会清理遗留目录。

## 参考源码

规范提炼自：

- `Can.h` / `Can.c` — 驱动层实现与 API
- `Can_Cfg.h` — 静态配置与类型
- `Can_PBcfg.c` — Post-Build 过滤器与映射表
- Boot 分步下载等复杂状态机函数（体内步骤注释范例）

典型工程路径：`tviibe1m/src/DiagStack/Can/`

## 贡献

欢迎提交 PR 增加 Dcm、CanTp、CanIf 等模块的注释规范或新 Skill。

1. Fork 本仓库
2. 在 `skills/` 下新建目录，包含 `SKILL.md`（必填）及可选 `examples.md`
3. 更新本 README 的 Skill 列表
4. 提交 Pull Request

## License

MIT — 见 [LICENSE](LICENSE)

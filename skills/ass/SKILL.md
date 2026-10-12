---
name: ass
description: >-
  ASS / ass / A / @ASS / /ASS (case-insensitive): DiagStack C/H comments + MISRA C
  code fixes in one pass. File banner, section blocks, .h brief / .c full Service
  Name, mandatory a./1. in-body steps for complex functions, then MISRA (Yoda,
  braces, 0U, (void), switch default). Trigger when user says ASS, @ASS, /ASS, A,
  ass, or asks for DiagStack comment + MISRA.
---

# ASS — DiagStack 注释 + MISRA C 改码

**短调用名（不区分大小写）**：`ASS` / `ass` / `@ASS` / `/ASS` / `A`

> 目录名必须为小写 `ass`（Cursor 要求 skill 文件夹用小写）；对话里仍可写 `ASS`。

任意项目对话中说上述任一即可触发。本 skill **始终**先加齐注释，再按 MISRA 改码。

参考基准：`tviibe1m/src/DiagStack/Can/` + Boot 分步下载等复杂 `.c`。

示例里的 `YYH` 只是版式样例。写入代码时按下面「作者名」取值，禁止照抄 `YYH`。

## 作者名（调用方自己的名字）

别人安装并调用本 skill 时，作者名不是仓库作者，也不是示例名。按顺序取，取到即停：

1. 本轮对话写明：`作者 ZS`、`author ZS`、`作    者 : ZS`
2. 当前工程根目录 `.ass-author`（仅一行名字，如 `ZS`）
3. 用户主目录 `.cursor/ass-author`（Windows：`%USERPROFILE%\.cursor\ass-author`；Linux / macOS：`~/.cursor/ass-author`）

都没有则写 `未知`。不要猜 git 用户名，不要留空（用户当次明确说「作者留空」时，作者列留空）。

改名：编辑上面其中一个文件，或当次对话带上作者名。skill 重装不会覆盖这两个文件（安装脚本只替换 `skills/ass/`）。

函数块 `Author` 与文件头「作    者」用同一名字，但受下一节「原先没有注释」约束。

## 修订记录：原先没有注释

先看目标文件有没有本规范文件头。

| 情况 | 作    者 / 函数 Author | 修订记录 |
|------|------------------------|----------|
| 本轮新建的文件或函数 | 调用方作者名；没有则 `未知` | 一行：`V1.0  当天  该作者  初始发布版本` |
| 已有代码，但没有本规范文件头（后来才补注释） | `未知`。原始作者不可考，不要写成补注释的人 | 第一行作者为 `未知`：`V1.0  未知  未知  初始发布版本`。下一行才是本次：`V1.1  当天  调用方作者  补充注释` |
| 已有本规范文件头 | 保持原作者，不改名 | 只在表尾追加一行，作者用调用方名字 |

后补注释时：文件头「版    本」改为本次修订号（上例为 `V1.1`），「日    期」改为本次日期。原先没有可靠日期时，初始行的日期列写 `未知`，不要编造。

## 执行顺序（必须）

1. **注释**：文件头、分区、`.h` 简写 / `.c` 完整 Service Name、复杂函数体内 `a.`/`1.` 步骤注释
2. **改码**：按下方 MISRA 条款修复；保持功能等价；改动处步骤注释仍要保留/更新
3. **自检**：无 `//`；复杂分支有体内步骤注释；无无括号控制语句；字面量带 `U`/`UL` 等后缀

## 何时套用

- 用户说「ASS」「@ASS」「/ASS」「A」「ass」（大小写均可）
- 用户要求 DiagStack 注释、Can 风格注释、并按 MISRA 改码
- 审查/整改 DiagStack 或 Boot `.c` / `.h`

---

# 第一部分：注释规范

## 语言与语气

- **文件头 / 功能描述 / 步骤注释 / 宏说明**：中文，技术准确、偏 AUTOSAR/驱动层表述
- **分区标题**：英文居中（Header Files、Static Variables 等）
- **Service Name**：与函数名一致，英文
- 避免口语

## 1. 文件头（每个 .c / .h 必须有）

新建文件（作者已配置为 `ZS`）：

```c
/*==============================================================================
* 文件名称 : Can.c
* 作    者 : ZS
* 版    本 : V1.0
* 日    期 : 2026-10-12
==============================================================================
* 功能描述 : 
* [一两句话说明本文件职责；可多行]
*
* 修订记录 :
* V1.0  2026-10-12  ZS  初始发布版本
==============================================================================*/
```

已有代码、原先没有注释，本次才补上（调用方作者 `ZS`）：

```c
/*==============================================================================
* 文件名称 : Can.c
* 作    者 : 未知
* 版    本 : V1.1
* 日    期 : 2026-10-12
==============================================================================
* 功能描述 : 
* [一两句话说明本文件职责；可多行]
*
* 修订记录 :
* V1.0  未知        未知  初始发布版本
* V1.1  2026-10-12  ZS    补充文件头与函数注释
==============================================================================*/
```

## 2. 一级分区（英文标题居中）

常用：Header Files、Type Definitions、Data Structure Definitions、Macros Definition、
Static Variables、Local Functions、Global Variables、Global Function Prototypes、
External Declarations、Global Functions。

```c
/*==================================================================================================
                                        Header Files
==================================================================================================*/
```

## 3. 函数注释（.h 简写 / .c 完整）

| 位置 | 风格 | 字段 |
|------|------|------|
| `.h` | 简写 | Service Name、Description、Author |
| `.c` / static | 完整 | 另加 Arguments、Return Value |

`.h` 不写 Arguments / Return Value；无参 / `void` 在 `.c` 写 `None`。

## 4. 函数体内步骤注释（必填）

复杂 / 多阶段 / 多分支函数**禁止**只写块头：

- 顶层：`a.` `b.` `c.` …
- 子步骤：`1.` `2.` `3.` …
- 写阶段意图与失败后果，不复述函数名

完整示例见 [examples.md](examples.md) 中 `Boot1_Download_FinishStep`。

## 5. 结构体 / 宏 / 文件尾

- 成员：`/**< 中文说明 */`
- 宏 / 初始化表：行尾 `/* 中文说明 */`
- 文件尾：`/* [] END OF FILE */`

---

# 第二部分：MISRA C 改码规则

目标：功能等价前提下贴近 **MISRA C:2012** 常见强制/必需习惯（嵌入式 / AUTOSAR 栈）。  
不臆造业务行为；不确定的偏离用注释标出原因，不强行破坏平台约定。

## M1. 注释与语言形态

| 规则 | 要求 |
|------|------|
| 禁止 `//` | 一律 `/* */`（含行尾） |
| 禁止空语句糊弄 | 不需要的返回值用 `(void)expr;` |

## M2. 控制结构与大括号

| 规则 | 不合格 | 合格 |
|------|--------|------|
| if/else/for/while/do 必须加大括号 | `if (x) return;` | `if (x) { return; }` |
| switch 必须有 `default` | 无 default | `default:` 分支（可 Abort / 断言语义） |
| 禁止落空 case | `case A: case B:` 无注释 | 空 case 用 `/* fall through */` 标明意图 |

## M3. 比较与 Yoda（DiagStack / Can 习惯）

| 规则 | 不合格 | 合格 |
|------|--------|------|
| 常量在左（防 `=` 误写） | `if (pnrc != NULL)` | `if (NULL != pnrc)` |
| 零比较用 `0U` / `0` 匹配类型 | `if (ret != 0)`（unsigned） | `if (0U != ret)` |
| 布尔用显式真假 | 依赖隐式 | `if (TRUE == bFlag)` 或项目既有布尔宏 |

## M4. 字面量与类型

| 规则 | 要求 |
|------|------|
| 无符号整型字面量 | `0U`、`1U`、`0xFFU`；需要时用 `UL` / `ULL` |
| 有符号与无符号混比 | 显式 cast 或统一类型后再比 |
| 窄化赋值 | 显式 `(uint8_t)` 等，并确认范围安全 |
| 指针与整型互转 | 必须经规定 typedef / 平台宏，禁止裸 cast 乱用 |

## M5. 返回值与副作用

| 规则 | 要求 |
|------|------|
| 忽略返回值 | `(void)Boot_FlagPara_ClearBootRequest(...);` |
| 错误路径成对 | Flash 失败 → `EndSession` + `Abort` + NRC（保持原设计语义） |
| 禁止隐式丢弃 | 不允许「调用了却既不判也不 (void)」 |

## M6. 宏与预处理器

| 规则 | 要求 |
|------|------|
| 函数式宏参数加括号 | `#define ADD(a,b) ((a)+(b))` |
| 宏体整体加括号 | 防止运算符优先级坑 |
| `#endif` 旁标注 | `#endif /* CAN_H */` |

## M7. 函数与可见性

| 规则 | 要求 |
|------|------|
| 文件内专用 | `static` |
| 原型与定义一致 | 参数名、类型、`const` 资格一致 |
| 不在头文件写代码体 | 除 `static inline` 且项目已允许 |

## M8. 改码时注释同步

- 每处 MISRA 结构性改动后，**保留/更新**对应 `a.`/`1.` 步骤注释
- 不要为“显得改过”而写与行为无关的长注释
- 若某处因硬件/SROM 约束无法完全符合某条 MISRA，在该处用一行 `/* MISRA 偏离：原因 */` 标明

## MISRA 改码对照示例（片段）

**不合格：**

```c
if (pnrc != NULL)
    *pnrc = DCM_NRC_OK;
if (ret) {
    return BOOT1_FINISH_FAIL;
}
Boot_FlagPara_ClearBootRequest(&s_stFinishMeta);
```

**合格（ASS）：**

```c
/* a. 可选输出初始化：默认 NRC 为 OK */
if (NULL != pnrc)
{
    *pnrc = DCM_NRC_OK;
}
if (0U != ret)
{
    return BOOT1_FINISH_FAIL;
}
(void)Boot_FlagPara_ClearBootRequest(&s_stFinishMeta);
```

复杂分步函数的完整注释范例见 [examples.md](examples.md)；ASS 在同类代码上再叠加本文件 M1–M8。

## 不要做的事

- 不要用 `//`
- 不要复杂函数只写 Service Name、函数体零步骤注释
- 不要为消 MISRA 告警而改变对外语义或删除错误处理
- 不要在 `.h` 写 Arguments / Return Value
- 不要省略文件头与 END OF FILE
- 不要把示例作者 `YYH` 写进调用方的代码
- 不要把后补注释的人写成「初始发布版本」的作者

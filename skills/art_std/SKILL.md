---
name: art_std
description: >-
  @art_std / /art_std (any case): the art skill plus AUTOSAR Classic public
  names (Adc_ReadTask), and magic numbers replaced by module macros. Same
  command as @ArtStd / /ArtStd / @artstd / /artstd. Bare art_std without @ or /
  does not trigger.
---

# @art_std / /art_std — art，并改公开函数名

和 `@art`、`/art` 一样，必须用 `@` 或 `/` 引出。大小写不限。`@ArtStd`、`/ArtStd`、`@artstd`、`/artstd` 是同一条指令。

没有 `@` 或 `/` 的 `art_std` 不触发。

先读完并执行同级的 [art](../art/SKILL.md)（安装后仍是 `../art/SKILL.md`）：注释、作者、MISRA 都按那个文件。读不到时，至少做下面这些，不要跳过：

1. 加齐 DiagStack 注释（文件头、分区、Service Name、复杂函数体内 `a.`/`1.` 步骤）
2. **强制**把不合规的公开函数改成 AUTOSAR Classic 名字，例如 `Adc_ReadTask`。声明、定义、调用和 Service Name 一起改。`static` 不改名
3. 按 MISRA 改码：无 `//`、控制语句加大括号、Yoda 比较、`0U` 等后缀、`(void)` 丢弃返回值、`switch` 有 `default`
4. **魔法数字提成宏**：通道号、长度、下标、超时、掩码、阈值、协议常量换成带中文说明的 `模块前缀_含义` 宏。`0`、`0U`、`1`、`1U` 除外。工程里已有同含义宏就沿用

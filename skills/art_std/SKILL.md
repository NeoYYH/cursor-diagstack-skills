---
name: art_std
description: >-
  @art_std / /art_std (any case): the art skill plus AUTOSAR Classic public
  names (Adc_ReadTask). Same command as @ArtStd / /ArtStd / @artstd / /artstd.
  Bare art_std without @ or / does not trigger.
---

# @art_std / /art_std — art，并改公开函数名

和 `@art`、`/art` 一样，必须用 `@` 或 `/` 引出。大小写不限。`@ArtStd`、`/ArtStd`、`@artstd`、`/artstd` 是同一条指令。

没有 `@` 或 `/` 的 `art_std` 不触发。

先读完并执行同级的 [art](../art/SKILL.md)（安装后仍是 `../art/SKILL.md`）：注释、作者、MISRA 都按那个文件。然后**强制**把不合规的公开函数改成 AUTOSAR Classic 名字，例如 `Adc_ReadTask`。声明、定义、调用和 Service Name 一起改。`static` 不改名。

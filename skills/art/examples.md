# DiagStack 注释示例（art / ART skill）

调用 **@art** / **ART**（不区分大小写）时：先按本示例加齐注释，再按 SKILL.md 中 MISRA 规则改码。要改已有公开函数名时说 **ArtStd** / **art_std** / **artstd**（大小写不限）。

> 磁盘目录必须是小写 `art/`。
>
> 默认作者是 `YYH`（`AUTHOR` 文件）。原先没有注释的文件，初始发布版本作者写 `未知`，不要写成后来补注释的人。

## 作者名示例

默认文件 `skills/art/AUTHOR`（安装后与 `SKILL.md` 同级）：

```text
YYH
```

不写作者、也不建 `.art-author` 时，新建文件用 `YYH`。

### 永久改成 ZS，并同步云端和本机

把仓库里的 `skills/art/AUTHOR` 改成一行 `ZS`，然后安装。脚本会把同一份写到 Cursor 扫描的两个目录。云端机器和本机各执行一次。

Linux / macOS（含云端）：

```bash
printf '%s\n' 'ZS' > skills/art/AUTHOR
./scripts/install.sh
```

Windows 本机：

```powershell
Set-Content -Path skills\art\AUTHOR -Value "ZS" -Encoding ascii
.\scripts\install.ps1
```

装完这两处都是 `ZS`：

- `%USERPROFILE%\.cursor\skills\art\AUTHOR`
- `%USERPROFILE%\.agents\skills\art\AUTHOR`

### 只改当前工程

工程根目录 `.art-author` 写一行 `ZS`。不改 `AUTHOR`，所以云端和其他工程仍是 `YYH`。

### 只改这一轮

`AUTHOR` 仍是 `YYH`，本轮记成 `LS`：

```text
@art 作者 LS 给 Can.c 补注释
```

### 默认 YYH，新建文件

对话：`@art 新建 Can.c`

```c
/*==============================================================================
* 文件名称 : Can.c
* 作    者 : YYH
* 版    本 : V1.0
* 日    期 : 2026-10-12
==============================================================================
* 功能描述 :
* 多通道 CAN/CAN-FD 驱动。
*
* 修订记录 :
* V1.0  2026-10-12  YYH  初始发布版本
==============================================================================*/
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Init
* Description : 遍历配置表，初始化已注册 CAN 通道
* Arguments   : None
* Return Value: None
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
```

### 默认 YYH，旧文件原来没有注释

`Can.c` 里已有 `Can_Init`，没有文件头。对话：`@art 给 Can.c 补注释`

文件头和旧函数不把 `YYH` 写成初始作者；`YYH` 只出现在本次修订行。本轮新写的函数才用 `YYH`。

```c
/*==============================================================================
* 文件名称 : Can.c
* 作    者 : 未知
* 版    本 : V1.1
* 日    期 : 2026-10-12
==============================================================================
* 功能描述 :
* 多通道 CAN/CAN-FD 驱动。
*
* 修订记录 :
* V1.0  未知        未知  初始发布版本
* V1.1  2026-10-12  YYH   补充文件头与函数注释
==============================================================================*/
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Init
* Description : 遍历配置表，初始化已注册 CAN 通道
* Author      : 未知
---------------------------------------------------------------------------------------------------
*/
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Write
* Description : 本轮新写的发送接口
* Arguments   : u8Channel - 通道号
*               pstPdu    - 待发送报文
* Return Value: E_OK / E_NOT_OK
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
```

`AUTHOR` 改成 `ZS` 后，上面新建和本次修订行里的 `YYH` 换成 `ZS`。初始发布版本那一行仍然是 `未知`。

## 公开函数命名

公开函数：模块前缀 + `_` + 每个单词首字母大写。读 ADC 的任务函数写成 `Adc_ReadTask`，不要写成 `Adc_Read_Task`。

### 只加注释：不改名

对话：`@art 给 adc_read_task 补注释`

```c
/*
---------------------------------------------------------------------------------------------------
* Service Name: adc_read_task
* Description : 周期读取 ADC 采样结果
* Arguments   : None
* Return Value: None
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
void adc_read_task(void)
{
    /* a. 启动转换并读回结果 */
}
```

### 写代码并套用注释标准：新函数按 AUTOSAR Classic

对话：`@art 写一个读 ADC 的任务函数`

```c
/*
---------------------------------------------------------------------------------------------------
* Service Name: Adc_ReadTask
* Description : 周期读取 ADC 采样结果
* Arguments   : None
* Return Value: None
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
void Adc_ReadTask(void)
{
    /* a. 启动转换并读回结果 */
}
```

同文件里已有的 `adc_read_task` 不是这次要写的函数，保持原名。

### ArtStd：加注释时也改公开函数名

`ArtStd`、`artstd`、`Artstd`、`ARTSTD`、`art_std` 是同一条指令。对话：`ArtStd 给 adc_read_task 补注释`

定义、声明和调用一起改，Service Name 用新名字：

```c
void Adc_ReadTask(void);

void Adc_ReadTask(void)
{
    /* a. 启动转换并读回结果 */
}

void App_Run(void)
{
    Adc_ReadTask();
}
```

`static` 函数不在这次改名范围内。

## 后补注释 — 初始作者未知

文件里已有代码、没有本规范文件头时，文件头与旧函数 `Author` 写 `未知`；本次补注释另记一行。

```c
/*==============================================================================
* 文件名称 : Can.c
* 作    者 : 未知
* 版    本 : V1.1
* 日    期 : 2026-10-12
==============================================================================
* 功能描述 : 
* 多通道 CAN/CAN-FD 驱动。
*
* 修订记录 :
* V1.0  未知        未知  初始发布版本
* V1.1  2026-10-12  YYH   补充文件头与函数注释
==============================================================================*/

/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Init
* Description : 遍历 g_apstCanCfgTable，初始化所有已注册 CAN 硬件通道
* Arguments   : None
* Return Value: None
* Author      : 未知
---------------------------------------------------------------------------------------------------
*/
```

本轮新写的函数仍用当前作者名（默认 `YYH`），不要写成 `未知`。

## Can.h — 文件头 + 分区 + 成员 + 原型（简写）

```c
/*==============================================================================
* 文件名称 : Can.h
* 作    者 : YYH
* 版    本 : V1.0
* 日    期 : 2026-06-18
==============================================================================
* 功能描述 : 
* 本文件为多通道 CAN/CAN-FD 驱动层的对外核心接口与数据模型定义头文件。
*
* 修订记录 :
* V1.0  2026-06-18  YYH  初始发布版本
==============================================================================*/

/*==================================================================================================
                                        Type Definitions
==================================================================================================*/

/*==================================================================================================
                                    Data Structure Definitions
==================================================================================================*/
struct Can_GroupHandleType_Tag
{
    uint8_t                    u8UnitId;       /**< 硬件单元物理索引号 (例如: 0=CAN0_CH0, 1=CAN0_CH1...) */
    const Can_HwProtocolType* pstProto;       /**< 指向协议配置实体的常指针（包含当前通道的波特率、时序精度等） */
};

/*==================================================================================================
                                   Global Function Prototypes
==================================================================================================*/
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Init
* Description : 遍历 g_apstCanCfgTable，初始化所有已注册 CAN 硬件通道
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
void Can_Init(void);
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Write
* Description : 发送 CAN 报文到指定硬件通道
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
Std_ReturnType Can_Write(uint8 u8Channel, const Can_PduType* pstPdu);
```

## Can.c — 完整函数块 + 壳函数群 + 函数体步骤

```c
/*==================================================================================================
                                        Global Functions
==================================================================================================*/
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Init
* Description : 遍历 g_apstCanCfgTable，初始化所有已注册 CAN 硬件通道
* Arguments   : None
* Return Value: None
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
void Can_Init(void)
{
    /* a. 遍历配置表，逐通道初始化 */
    ...
}

/*--------------------------------------------------------------------------------------------------
* 物理通道 Rx 壳函数群 (物理通道 0 ~ 4)
* 由底层硬件中断服务程序(ISR)在成功接收标准/扩展数据帧后直接唤醒。
--------------------------------------------------------------------------------------------------*/
static void Can_Internal_RxMsgDispatcher(...);

void Can_FD0_RxMsgCallback(...)
{ Can_Internal_RxMsgDispatcher(0U, ...); }

/*==================================================================================================
                                        Local Functions
==================================================================================================*/
/*
---------------------------------------------------------------------------------------------------
* Service Name: Can_Internal_Init
* Description : 单通道硬件初始化：引脚、协议、寄存器配置
* Arguments   : pstHandle - 指向当前待配置通道静态全局配置结构体的指针
* Return Value: None
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
static void Can_Internal_Init(const Can_GroupHandleType *pstHandle)
{
    /* a. 安全拦截：防止空指针引发内核硬件异常 */
    if (pstHandle == NULL)  return;

    /* b. 引脚配置初始化：配置当前通道 TX 和 RX 引脚的强推挽与高阻态输入属性 */
    ...

    /* g. 外设核硬初始化使能：调用官方驱动库写入配置字至相应物理寄存器空间 */
    Cy_CANFD_Init(pstIndxMap->stdCanType, &stcCanConfig);
}
```

## Can_Cfg.h — 宏 + 条件编译说明

```c
#define CAN_INSTANCE_MAX                    (5U)                             /* 芯片硬件支持的最大 M-CAN 物理实例总数 */
#define CAN_DIAG_CONTROLLER_ID              (2U)                             /* 诊断 / UDS / FOTA 报文绑定的 CAN 物理通道 ID */

#ifdef BOOT0_SUPPLIER_FBL
/* SROM syscall 要求 IRQ0=1/IRQ1=0 为最高；CAN 不可与其同级 (AN220242/FAQ 14.1) */
#define CANFD_INTERRUPT_PRIORITY            (2U)
#else
#define CANFD_INTERRUPT_PRIORITY            (1U)
#endif
```

## Can_PBcfg.c — 编号分区 + 过滤器行注释

```c
/*==============================================================================
* 1. 硬件过滤器配置 (Rx ID Filters)
==============================================================================*/
/* ------------------- 句柄2 (M-CAN 0 通道2) 诊断通道过滤器 — 对齐 PK2C BOOT1 ------------------- */
static const cy_stc_id_filter_t stdIdFilter_STD2[] =
{
    /* 物理ID精确匹配：标准帧接收过滤器，匹配 PhyID_RLCM_L (0x010)，存入硬件 Rx Buffer 索引 0 */
    CANFD_CONFIG_STD_ID_FILTER_CLASSIC_RXBUFF(PhyID_RLCM_L, 0u),
};

/*==============================================================================
* 2. 硬件通道控制与过滤器绑定表 (Mapping Table)
==============================================================================*/
const Can_HwMappingConfigType Can_HwMappingTable[Can_HwMT_MAX] = {
    /* --- 索引0: CAN_TYPE_00 映射配置 --- */
    {
        .pfnTxCb        = Can_FD0_TxMsgCallback,            /* 硬件发送完成中断回调函数指针 */
        .bIsFdMode      = (USE_CANFD00_MODE == 1),          /* 是否激活 CAN-FD 柔性数据速率模式 */
    },
};
```

## Boot1_Download.c — 复杂分步函数（完整块头 + 函数体步骤注释）

多阶段状态机（IDLE → ERASE → COPY → META）必须同时有 Service Name 块注释与函数体内 `a.` / `1.` 步骤注释；禁止只写块头、函数体零注释。

```c
/*
---------------------------------------------------------------------------------------------------
* Service Name: Boot1_Download_FinishStep
* Description : 0x37 分步完成：校验、擦活动区、拷贝、更新 FlagPara 元数据
* Arguments   : pnrc - 可选负响应码输出指针
* Return Value: BOOT1_FINISH_OK / BOOT1_FINISH_PENDING / BOOT1_FINISH_FAIL
* Author      : YYH
---------------------------------------------------------------------------------------------------
*/
Boot1_FinishResultType Boot1_Download_FinishStep(Dcm_NegativeRespType* pnrc)
{
    uint32_t u32SectorSize;

    /* a. 可选输出初始化：默认 NRC 为 OK */
    if (NULL != pnrc)
    {
        *pnrc = DCM_NRC_OK;
    }

    /* b. 时序守卫：仅允许在 Transferring 态进入分步完成 */
    if (s_eState != BOOT1_DL_TRANSFERRING)
    {
        if (NULL != pnrc)
        {
            *pnrc = DCM_NRC_REQUEST_SEQUENCE_ERROR;
        }
        return BOOT1_FINISH_FAIL;
    }

    /* c. IDLE 入口：长度校验、流刷盘、镜像校验，再切入擦除阶段 */
    if (s_eFinishPhase == BOOT1_FINISH_PHASE_IDLE)
    {
        /* 1. 接收长度必须与约定镜像大小一致 */
        if (s_u32Received != s_u32ImageSize)
        {
            if (NULL != pnrc)
            {
                *pnrc = DCM_NRC_GENERAL_PROGRAMMING_FAILURE;
            }
            return BOOT1_FINISH_FAIL;
        }

        /* 2. 刷出剩余编程缓冲 */
        if (0U != Boot1_CodeFlash_StreamFlush())
        {
            if (NULL != pnrc)
            {
                *pnrc = DCM_NRC_GENERAL_PROGRAMMING_FAILURE;
            }
            return BOOT1_FINISH_FAIL;
        }

        /* 3. 校验后备区镜像有效性 */
        if (0U == Boot1_Download_ValidateImage(BOOT1_BOOT2_BACK_ADDR))
        {
            if (NULL != pnrc)
            {
                *pnrc = DCM_NRC_GENERAL_PROGRAMMING_FAILURE;
            }
            return BOOT1_FINISH_FAIL;
        }

        /* 4. 准备 CodeFlash 会话并进入 ERASE */
        Boot1_CodeFlash_Prepare();
        s_u32FinishOffset = 0U;
        s_eFinishPhase = BOOT1_FINISH_PHASE_ERASE;
    }

    /* d. 喂狗：分步擦写耗时，防止外部看门狗复位 */
    UJA1169_FeedWatchdog();

    /* e. ERASE：按扇区擦活动 Boot2，单次返回 PENDING */
    if (s_eFinishPhase == BOOT1_FINISH_PHASE_ERASE)
    {
        /* 1. 未擦完：擦当前扇区后推进偏移并挂起 */
        if (s_u32FinishOffset < BOOT1_BOOT2_CODE_SIZE)
        {
            u32SectorSize = Boot1_CodeFlash_GetSectorSize(BOOT1_BOOT2_ENTRY_ADDR + s_u32FinishOffset);
            if (0U != Boot1_CodeFlash_EraseSector(BOOT1_BOOT2_ENTRY_ADDR + s_u32FinishOffset))
            {
                Boot1_CodeFlash_EndSession();
                Boot1_Download_FinishAbort();
                if (NULL != pnrc)
                {
                    *pnrc = DCM_NRC_GENERAL_PROGRAMMING_FAILURE;
                }
                return BOOT1_FINISH_FAIL;
            }
            s_u32FinishOffset += u32SectorSize;
            return BOOT1_FINISH_PENDING;
        }

        /* 2. 擦完：复位偏移，切入 COPY */
        s_u32FinishOffset = 0U;
        s_eFinishPhase = BOOT1_FINISH_PHASE_COPY;
        return BOOT1_FINISH_PENDING;
    }

    /* f. COPY：按行从后备区拷到活动区，单次返回 PENDING */
    if (s_eFinishPhase == BOOT1_FINISH_PHASE_COPY)
    {
        /* 1. 未拷完：CopyRow 失败则结束会话并 Abort */
        if (s_u32FinishOffset < s_u32ImageSize)
        {
            if (0U != Boot1_CodeFlash_CopyRow(BOOT1_BOOT2_ENTRY_ADDR + s_u32FinishOffset,
                                              BOOT1_BOOT2_BACK_ADDR + s_u32FinishOffset))
            {
                Boot1_CodeFlash_EndSession();
                Boot1_Download_FinishAbort();
                if (NULL != pnrc)
                {
                    *pnrc = DCM_NRC_GENERAL_PROGRAMMING_FAILURE;
                }
                return BOOT1_FINISH_FAIL;
            }
            s_u32FinishOffset += BOOT1_CF_ROW_SIZE;
            return BOOT1_FINISH_PENDING;
        }

        /* 2. 拷完：切入 META */
        s_eFinishPhase = BOOT1_FINISH_PHASE_META;
        return BOOT1_FINISH_PENDING;
    }

    /* g. META：结束 Flash 会话，清启动请求并回写 FlagPara */
    if (s_eFinishPhase == BOOT1_FINISH_PHASE_META)
    {
        Boot1_CodeFlash_EndSession();
        Boot_FlagPara_Read(&s_stFinishMeta);
        (void)Boot_FlagPara_ClearBootRequest(&s_stFinishMeta);
        if (0U == Boot_FlagPara_Write(&s_stFinishMeta))
        {
            if (NULL != pnrc)
            {
                *pnrc = DCM_NRC_GENERAL_PROGRAMMING_FAILURE;
            }
            Boot1_Download_FinishAbort();
            return BOOT1_FINISH_FAIL;
        }
        Boot1_Download_Reset();
        return BOOT1_FINISH_OK;
    }

    /* h. 未知阶段兜底：GENERAL_REJECT + Abort */
    if (NULL != pnrc)
    {
        *pnrc = DCM_NRC_GENERAL_REJECT;
    }
    Boot1_Download_FinishAbort();
    return BOOT1_FINISH_FAIL;
}
```

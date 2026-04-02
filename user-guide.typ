#import "@preview/dashy-todo:0.0.3": todo

#set text(
  font: ("Noto Sans", "Source Han Sans SC", "Microsoft YaHei"),
  size: 11pt,
  lang: "zh",
  region: "cn",
)

#set par(leading: 0.8em, spacing: 1.2em)

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(8pt, gray)
      #grid(
        columns: (1fr, 1fr),
        [PocketTX 用户手册],
        align(right)[版本: v1.1]
      )
      #v(-0.5em)
      #line(length: 100%, stroke: 0.5pt + gray)
    ]
  },
  footer: context [
    #align(center, text(9pt, gray)[第 #counter(page).display() 页])
  ],
)

#set heading(numbering: "1.1 ")
#show heading: it => {
  v(1.2em, weak: true)
  it
  v(0.6em)
}

#show outline.entry: set par(leading: 1.2em)

// 辅助函数：绘制占位/实物图
#let placeholder(caption, img_path: none, height: 10em, width: 100%) = figure(
  if img_path != none {
    image(img_path, width: width)
  } else {
    rect(width: 100%, height: height, stroke: 1pt + navy, fill: luma(250), radius: 4pt)[
      #align(center + horizon)[
        #text(gray, size: 14pt)[#caption] \
        #v(0.5em)
        #text(gray, size: 9pt)[请在此替换为实物照片或界面截图]
      ]
    ]
  },
  caption: caption,
)

#let trimmed-image = (path, trim: (:), alt: none) => context {
  let img = image(path)
  // Get dimensions of the source image
  let dims = measure(img)

  layout(size => {
    let left = trim.at("left", default: 0.0%)
    let right = trim.at("right", default: 0.0%)

    let top = trim.at("top", default: 0.0%)
    let bottom = trim.at("bottom", default: 0.0%)

    let width-rel-trimmed = 100.0% - left - right
    let height-rel-trimmed = 100.0% - top - bottom

    let width-source-trimmed = dims.width * width-rel-trimmed
    let height-source-trimmed = dims.height * height-rel-trimmed

    // Aspect ratio h/w of the layout (available space)
    let aspect-height-layout = size.height / size.width
    // Aspect ratio h/w of the trimmed image
    let aspect-height-trimmed = height-source-trimmed / width-source-trimmed

    let width-final-trimmed = none
    let height-final-trimmed = none

    // Compute final size of trimmed image 
    // by expanding along dimension that first hits the layout constraints
    if aspect-height-layout >= aspect-height-trimmed {
      // Expand width of image
      width-final-trimmed = size.width
      height-final-trimmed = aspect-height-trimmed * width-final-trimmed
    } else {
      // Expand height of image
      height-final-trimmed = size.height
      width-final-trimmed = size.height / aspect-height-trimmed
    }

    // Compute the hypothetical size of the image without trimming
    let width-final-untrimmed = width-final-trimmed / float(width-rel-trimmed)
    let height-final-untrimmed = height-final-trimmed / float(height-rel-trimmed)

    box(
        clip: true,
        inset: (
            top: -(top * height-final-untrimmed),
            bottom: -(bottom * height-final-untrimmed),
            left: -(left * width-final-untrimmed),
            right: -(right * width-final-untrimmed)
          ),
      // TODO: Handle explicit sizing according to a parameter (e.g. don't scale over DPI limits)
        image(path, width: width-final-untrimmed, height: height-final-untrimmed, alt: alt)
      )
  })
}

#let caution(body) = block(
  fill: rgb("#fff5f5"),
  stroke: (left: 4pt + red),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
  [*注意：* #body],
)

#let tip(body) = block(
  fill: rgb("#f0f8ff"),
  stroke: (left: 4pt + blue),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
  [*提示：* #body],
)

// 封面
#align(center + horizon)[
  #block(inset: 3em)[
    #text(28pt, weight: "bold", fill: navy)[PocketTX] \
    #v(0.4em)
    #text(18pt, weight: "medium")[用户使用手册] \
    #v(1.2em)
    #text(11pt, gray)[面向零基础用户的轻量级航模遥控解决方案]
  ]
  
  #placeholder("产品外观示意图", img_path: "assets/1.png", height: 15em)
  
  #v(1fr)
  #text(10pt, gray)[文档版本：v1.1.0 | 最后更新：2026年4月2日] \
  #text(10pt, gray)[适用硬件：PocketTX v1.0.0 及以上]
]

#pagebreak()

// 目录
#outline(indent: 2em, depth: 2)

#pagebreak()

= 产品简介 <intro>

== 什么是 PocketTX？
*PocketTX *是一款将安卓手机控制信号转换为 ELRS 发射信号的小型外设。

设备通过手机 Type-C 接口接收 APP 输出的控制数据，在内部转换为 *Crossfire (CRSF)* 协议，再由内置 ELRS 发射端发送给接收机。它的主要用途是让用户在便携场景下完成基础飞行控制与调试。

== 核心技术亮点
- 采用 USB 串口桥接方案，实现手机与射频模块之间的数据通信。
- 基于 ExpressLRS (ELRS) 架构实现发射功能，支持常见 ELRS 接收机链路。
- 设备由手机 Type-C 接口供电，无需额外发射电池。
- 集成 1S 电池充电电路，典型充电电流约 500mA。

= 硬件概览 <hardware>

#placeholder("硬件接口与按键分布标注图", img_path: "assets/2.png")

== 详细接口说明
1. *Type-C 公头*
   - 这是设备用于连接手机的接口。它负责信号输入与电力获取。请注意，插入时应确保接口完全到位，避免因手机壳过厚导致的接触不良。

2. *充电接口 (MH1.25)*
   - 位于设备侧面。您可以在此处接入 1S 锂电池进行充电。虽然接口支持快插，但请在插入前仔细确认电池正负极。
#placeholder("电池接口连接示意图", img_path: "assets/3.png")
3. *内置 ELRS 天线*
   - 射频信号通过内部天线发射。使用时请尽量避免用手紧握设备的天线位置，以免遮挡信号导致遥控距离缩短。
   - 天线位于设备末端（无充电口一侧）

== 指示灯状态逻辑表
设备顶部设有两枚指示灯，分别反馈系统与充电状态：
#placeholder("指示灯分布示意图", img_path: "assets/4.png")
#table(
  columns: (1fr, 1.5fr, 2fr),
  inset: 8pt,
  align: horizon + center,

  [*指示灯*], [*显示状态*], [*详细含义*],

  table.cell(rowspan: 4)[
    *系统工作灯* \
    *(红色)*
  ],
  [常亮],
  [已连接飞控，链路正常],

  [缓慢闪烁],
  [配对中（未连接到飞控）],

  [快速闪烁],
  [进入 WiFi 配置模式],

  [常灭],
  [进入烧录（Boot）模式],

  table.cell(rowspan: 2)[*充电指示灯*],
  [红色常亮],
  [正在充电 (CHG)],

  [绿色常亮],
  [已充满或处于待机状态 (STB)],
)

== Boot 按钮
这是一个隐藏式的物理按键，主要用于*底层固件维护*。当您需要刷写新版 ExpressLRS 固件时，该按钮是进入烧录模式的唯一方法。在日常操控过程中，请勿按压此键。

= 快速上手指引 <quick-start>

== 第一步：软件环境准备
由于 Android 系统的多样性，我们建议您按照以下步骤准备：
1. 从官方渠道下载PocketTX专用的App（Let's Fly)，并安装到您的手机上。
App下载地址：#link("https://github.com/HumpbackLab/LetsFly/releases")[https://github.com/HumpbackLab/LetsFly/releases]


2. 安装时，手机可能会提示“未知来源风险”，请选择“允许安装”。

== 第二步：物理互联流程
#placeholder("手机与转换器连接示意图", height: 12em, img_path: "assets/5.png")

将转换器插入手机。如果您的手机预先下载安装了官方的App（Let's Fly)，这里会弹出相关的提示，引导您打开Let's Fly App。

== 第三步：操控配置与校准
#placeholder("Let's Fly app 界面布局图", img_path: "assets/6.png", width: 60%)

1. *建立连接*：点击界面上的 *Connect* 按钮。如果设备已正确插入且权限已授予，应用将通过USB接口向设备进行通信。连接成功后，系统工作灯将进入呼吸闪烁状态。

2. *遥控布局*：
   - *单手模式*：仅使用单摇杆控制，垂直方向为 *油门 (Throttle)*，水平方向为 *偏航 (Yaw)*，适合简单飞行或初学者入门。
   - *双手模式*：类似游戏手柄的双摇杆布局：
     - *左摇杆*：垂直方向控制 *油门 (Throttle)*，水平方向控制 *偏航 (Yaw)*。
     - *右摇杆*：垂直方向控制 *俯仰 (Pitch)*，水平方向控制 *横滚 (Roll)*。
   - 默认情况下，油门摇杆不回中，保持在您放置的位置。
   - 设置页面中，可以调整各个摇杆的灵敏度，以适应不同飞行风格和飞机特性。

3. *体感控制模式 (Gyro Mode)*：
   - 在双手模式下，在设置页面中，可以切换至体感操控。在此模式下，您可以通过倾斜手机来控制飞机的俯仰与横滚。
   - *油门控制*：由于手机倾斜无法精确控制油门，体感模式下需使用手机侧面的 *音量键* 来增减油门读数。
   - *安全自动锁*：当您的手机倾斜角度过大（例如完全翻转或竖立）时，App 会自动关闭 Arm 开关实现紧急停机，保护人员安全。
4. *调试信息显示*
  - 在设置中可以打开调试开关，从而可以查看当前的实时 CRSF 通道数值（典型范围：172-1811），并可同时查看手机姿态相关调试信息（如 roll、pitch、yaw），便于联调与状态确认。

= 配置、对频与 Web UI <configuration>
#v(0.5em)
#caution[
  修改 ExpressLRS 核心参数（如发射功率、包速率等）可能会直接导致信号链路中断、控制距离缩减甚至发生严重失控。\
  请仅在充分理解相关参数含义、并处于合规无线电环境下进行调整，在专业人士的指导下进行配置。\
  由于配置不当导致的设备损毁或人身财产损失，由用户承担全部责任。]
==  对频密码 (Binding Phrase)
ExpressLRS 采用了现代的动态对频机制。只要在发射端（本设备）和接收机端设置相同的*“对频字符串”*，它们在通电后就会自动完成握手。\
如果您需要调整对频密码，可以通过下述的WiFI配置管理页面进行。

#v(0.5em)
#tip[
  *关于接收机 (Receiver)*：
  请确保您的飞机接收机也已配置了*完全一致*的对频密码。
  - 如果您使用的是我们的套装接收机，密码已预设好，无需操作。
  - *第三方接收机*：本产品支持但不建议用户自行连接其他接收机。在连接第三方接收机的时候，请检查对频密码，并且请务必核对*通道映射*。本设备输出顺序为 AETR（1-油门, 2-横滚, 3-俯仰, 4-偏航），请在确保安全的条件下进行测试。
]

== 如何进入 WiFi 配置管理页面<wificonf>
1. *进入方式*：将本设备插入手机并供电，静置约 60 秒不要进行任何操控，设备会自动发射出一个名为 `ExpressLRS TX` 的热点。
2. *连接热点*：使用您的电脑或手机连接该热点，默认密码为 `expresslrs`。
3. *访问后台*：打开浏览器，在地址栏输入 `10.0.0.1` 即可进入管理后台。

#placeholder("ELRS 配置后台界面截图", img_path: "assets/7.png")

= 固件升级与维护 <firmware>

当社区发布了更新的 ELRS 版本时，您可以手动升级本设备的固件。

#v(0.5em)
#box(stroke: 1pt + red, inset: 12pt, fill: rgb("#fff5f5"), radius: 4pt, width: 100%)[
  *🛑 固件刷写注意事项*：
  1. 刷写第三方或非官方固件属于高风险行为，可能导致硬件“变砖”（永久损坏）且无法恢复到出厂固件。
  2. 用户自行刷写固件即代表自愿放弃保修权利。本公司不对因固件刷写失败、版本不匹配或固件漏洞导致的任何直接或间接后果承担法律责任。
  3. 建议用户在专业人士指导下进行
]\
#v(0.5em)
#tip[
我们提供了以下两种固件更新方式。对于大多数用户，我们*强烈推荐*使用*方式 1（WiFi 配置页）*进行升级，该方式最为便捷且风险较低。
方式 2需要用户具备一定的软硬件基础知识，主要适用于*高级用户开发调试或需要深度定制功能*的场景。]
\
== 烧录方式1：使用WiFi配置页在线烧录 (推荐)
#placeholder("WiFi配置页在线烧录固件示意图", img_path: "assets/8.png")

参考@wificonf 的内容，进入WiFi配置页面。

在页面中选择上传选项，随后上传想要烧录的固件，点击蓝色的上传按钮，等待烧录完成，设备会自动进行重启。

PocketTX固件更新地址：
- #link("https://github.com/HumpbackLab/PocketTX-manual/releases/latest")[https://github.com/HumpbackLab/PocketTX-manual/releases/latest]
== 烧录方式2：进入引导模式 (Bootloader)
#v(0.5em)
#caution[
  *严格操作顺序*：
  1. 确认设备*未连接*任何电源或手机，处于未通电状态。
  2. 使用回形针或 SIM 卡顶针，对准并*按住*设备机身上的 *Boot 键*（通常位于外壳小孔内部）。
  3. 在保持按住 Boot 键的状态下，将设备 Type-C 接口插入手机或电脑，为设备通电。
  4. 插入后等待 2-3 秒，即可*松开* Boot 键，此时设备即进入 Bootloader 模式。
]

=== 烧录步骤
1. *环境准备*：在电脑中打开 `VS Code` 软件，确保已安装并启用 `PlatformIO` 插件。
2. *获取源码并切换分支*：在终端依次执行以下命令：
  - `git clone https://github.com/ExpressLRS/ExpressLRS`
  - `cd .\ExpressLRS`
  - `git checkout 3.x.x-maintenance`
  - `cd src`
  - `git clone -b feat/pockettx-2g4-v1 https://github.com/HumpbackLab/targets.git Hardware`
  - `code .`
3. *打开工程*：在 VS Code 中打开当前目录，等待 PlatformIO 完成项目索引。
4. *目标选择*：在 PlatformIO 的环境列表中选择 `Unified_ESP8285_2400_TX_via_UART` 项目环境（该项与旧流程一致）。
5. *编译或烧录*：点击 `Build` 可仅生成固件；点击 `Upload` 可直接烧录设备。
6. *硬件确认*：当终端弹出硬件选择菜单时，输入 `2` 并选择 `2) PocketTX 2.4G V1.0`。
7. *状态验证与排查*：确认编译或烧录流程 100% 完成。若提示端口异常，请重新执行“进入引导模式”并检查 `CH340` 驱动。

= 电池充电系统指引 <charging>

本设备内置了一套成熟的线性充电方案，专为航模电池设计。

== 充电技术特性
- *恒流充电*：当电池电压较低时，它会以额定电流（约 500mA）快速补电。
- *恒压阶段*：当电压接近 4.2V 时，电流会平滑下降，确保电池充满且不过充。
- *温度监控*：本设备具备基础的过热保护，如果感觉转换器外壳烫手，可以暂停充电，等待设备冷却。

== 充电操作规范
1. *连接电源*：将转换器插入手机。建议此时保证手机电量充足。
2. *插入电池*：观察极性，插入与充电接口匹配的电池。
3. *观察指示灯*：充电中为红灯常亮；充满或待机状态为绿色常亮。
4. *充满移除*：建议结合充电时间与电池电压判断充满状态，确认后即可拔出。

== 安全事项 (请务必阅读)
- *严禁接入 2S/3S 电池*：本电路最高耐压仅能支撑单节锂电 (4.2V)。接入高压电池会烧毁芯片。
- *空间环境*：充电时请勿将设备放在床单、地毯等易燃物上。
- *严禁反接*：虽然电池接口有机械防反接，但强行反接会导致电池短路甚至起火。

= 常见问题排查 (FAQ) <faq>

/ 问：对频不成功，即使密码一样？: 答：请确认两端的固件大版本号（V2 或 V3）是否一致。ELRS 的 V2 和 V3 版是不互通的。

更多问题正在收集与更新中...

其他问题请访问官网：https://humpbacklab.github.io/ 或加入交流 QQ 群：763833895 咨询。

= 法律免责与安全警告 <legal>

1. *合规性声明*：使用本产品前，请务必了解您所在国家/地区关于 2.4GHz 无线电发射的相关法律。
2. *操作责任*：航模运动具有一定危险性。由于 APP 虚拟摇杆不同于真实物理摇杆，初期练习请务必在空旷场地进行。
3. *损毁免责*：本公司不对因操作不当、固件刷写失败或充电违规导致的手机、电池或飞机的损坏承担法律责任。

= 附录：原理图 <schematic-appendix>

以下为 PocketTX 当前版本原理图：

#figure(
  image("schematic/PocketTX_Schematic_2026-03-13.pdf", page: 1, width: 100%),
  caption: [PocketTX 原理图（第 1 页）],
)

以上原理图也可以在以下链接下载查看：
- #link("https://github.com/HumpbackLab/PocketTX-manual/releases/latest/")[https://github.com/HumpbackLab/PocketTX-manual/releases/latest/] 
- release -> Assets -> PocketTX_Schematic_2026-03-13.pdf

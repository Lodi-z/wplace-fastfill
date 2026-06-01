#Include <StringTools>
#Include <IMETools>
class SettingGui {
    /**@type {Gui}*/
    static instance := false
    static settingsMap := false
    static Show() {
        if !this.instance {
            this.instance := Gui()
            this.instance.Title := "Wplace工具 - 菜单                  Ciallo～(∠・ω< )⌒★"

            ; 字体设置 - 使用对象
            fonts := {
                h2: "s12 bold",
                h3: "s11 bold",
                body: "norm s11"
            }

            ; 位置设置 - 使用对象
            transforms := {
                h1: "x30 y10 h20",
                h1_yp: "yp h20",
                h2_first: "x30 y70 h20",
                h2: "x30 y+5 h20",
                h3: "x40 y+5 h16",
                body: "x50 y+3 h12",
                body_setting: "x50 y+3 h20",
                body_setting_yp: "yp h20"
            }

            ; 获取设置映射
            settingsMap := this.GetSettingsMap()

            ; 作者信息
            this.instance.SetFont(fonts.h2)
            this.instance.AddText(transforms.h1, "作者：洛迪")
            this.instance.SetFont(fonts.body)
            this.instance.AddLink(transforms.h1_yp, ' | <a href="https://space.bilibili.com/418324770">b站主页</a>')
            this.instance.AddLink(transforms.h1_yp, ' | <a href="https://afdian.com/a/luodi">爱发电主页</a>')

            tab := this.instance.AddTab3("x18 y29 w480 h560", ["介绍", "设置", "赞助"])

            ; 介绍标签页
            tab.UseTab("介绍")
            this.AddIntroContent(tab, fonts, transforms)

            ; 设置标签页
            tab.UseTab("设置")
            this.AddSettingsContent(tab, fonts, transforms, settingsMap)

            ; 赞助标签页
            tab.UseTab("赞助")
            this.instance.AddPicture("x18 y50 w476 h540", "image/QR_code.jpg")

            tab.UseTab()

            ; 底部按钮
            this.AddBottomButtons(settingsMap)

            ; 装饰表情包图片
            this.instance.AddPicture("x435 y0 w61 h50 vDecoration")
            this.ChangedDecoration()
            tab.OnEvent("Change", (*) => this.ChangedDecoration())

            ; 注册事件
            this.instance.OnEvent("Close", (*) => this.OnStartClick(settingsMap))

            this.instance.Show("w514")
            IME.SetEnglish()
        }
    }

    ; 介绍
    static AddIntroContent(tab, fonts, transforms) {
        GetDescribeByKeyMode(keyData) {
            describe_map := Map(
                KeyMode.heldDown, "按住 {} 期间进入此模式",
                KeyMode.toggle, "按下 {} 进入此模式，再次按下时退出",
                KeyMode.directly, "直接使用 {} 执行功能"
            )
            return Format(describe_map[Integer(keyData.mode)], StringTools.HotkeyToString(keyData.key))
        }

        GetKeyName(keyData) {
            return keyData.mode = KeyMode.directly ? StringTools.HotkeyToString(keyData.key) : StringTools.HotkeyToString(_SettingsData.triggerKey)
        }

        ; 功能说明标题
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2_first, "功能说明：")
        this.instance.SetFont(fonts.body)

        ; 功能列表
        functions := [
            {
                name: "织色如缕",
                color: "0071d4",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.fillKey),
                    Format("• 长按{}：对鼠标移动途中连续填充当前颜色", GetKeyName(_SettingsData.fillKey))
                ]
            },
            {
                name: "摄色流转",
                color: "0c8d00",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.pickAndDrawKey),
                    Format("• 点击{}：取色当前颜色后立即填入", GetKeyName(_SettingsData.pickAndDrawKey)),
                    "• 继续长按：滑动到相同颜色时自动填充"
                ]
            },
            {
                name: "绘彩巡游",
                color: "bc0000",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.fillOnHoverPickOnClickKey),
                    "• 始终执行：鼠标滑动到相同颜色时自动填充",
                    Format("• 点击{}：取色当前颜色后立即填入", StringTools.HotkeyToString(_SettingsData.triggerKey)),
                    "• 长按WASD：可控制鼠标移动，使用Shift加速，Ctrl减速"
                ]
            },
            {
                name: "纵穿千影",
                color: "6f00d7",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.DrawVerticalKey),
                    Format("• 按住shift时点击{}：取色当前颜色后立即填充整列相同颜色", GetKeyName(_SettingsData.DrawVerticalKey)),
                    Format("• 点击{}：立即填充整列上次取色的相同颜色", GetKeyName(_SettingsData.DrawVerticalKey))
            ]
            },
            {
                name: "横扫苍茫",
                color: "c8a700",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.DrawHorizontalKey),
                    Format("• 按住shift时点击{}：取色当前颜色后立即填充整行相同颜色", GetKeyName(_SettingsData.DrawHorizontalKey)),
                    Format("• 点击{}：立即填充整行上次取色的相同颜色", GetKeyName(_SettingsData.DrawHorizontalKey))
                ]
            }
        ]

        for func in functions {
            this.instance.SetFont(fonts.h3)
            this.instance.AddText(transforms.h3, func.name).SetFont("c" func.color)
            this.instance.SetFont(fonts.body)
            this.instance.AddPicture("yp w15 h15", StatusGui.ImageFiles[A_Index])
            for desc in func.desc {
                this.instance.AddText(transforms.body, desc)
            }
        }

        ; 其他功能
        this.instance.SetFont(fonts.h3)
        this.instance.AddText(transforms.h3, "其他功能")
        this.instance.SetFont(fonts.body)
        this.instance.AddText(transforms.body, "• 鼠标中键拖动：移动画布（地图）")
        this.instance.AddText(transforms.body, "• 右键擦除颜色，上下左右移动画布（网站原有功能）")

        ; 注意事项
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2, "注意事项：")
        this.instance.SetFont(fonts.body)
        this.instance.AddText(transforms.body, "如果无法启用，请检查是否启用了自动翻译，标题不能被翻译")
        this.instance.AddText(transforms.body, "如果【取色后立即填入该颜色】功能无法触发，请调高取色延迟！")
    }

    ; 设置
    static AddSettingsContent(tab, fonts, transforms, settingsMap) {
        labelWidth := " w120"
        EditWidth := " w110"
        DropDownWidth := " w125"

        KeyModeOptions := ["按住时使用模式", "按下后切换模式", "直接触发"]
        KeyModeOptions2 := ["按住时使用模式", "按下后切换模式"]

        ; 启动设置
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2_first, "启动设置")
        this.instance.SetFont(fonts.body)
        this.instance.AddCheckbox(transforms.body_setting " vOpenThisPage", "启动时自动打开本页面").Value := _SettingsData.openThisPageOnStart
        this.instance.AddCheckbox(transforms.body_setting " vOpenWplace", "启动时自动打开Wplace网站").Value := _SettingsData.openWplaceOnStart
        this.instance.AddLink(transforms.body_setting_yp, '<a href="' _SettingsData.wplaceWeb '">' _SettingsData.wplaceWeb '</a>')
        this.instance.AddCheckbox(transforms.body_setting " vOpenCustom", "启动时自动打开自定义程序").Value := _SettingsData.openCustomOnStart
        this.instance.AddEdit(transforms.body_setting_yp " vCustomUrl w160", _SettingsData.customUrl)

        ; 键位设置
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2, "键位设置（为空时表示不使用该功能）")
        this.instance.SetFont(fonts.body)

        keys := [
            {
                label: "打开菜单：",
                hotkey: "PauseKey",
                value: _SettingsData.menuKey
            },
            {
                label: "织色如缕：",
                hotkey: "FillKey",
                value: _SettingsData.fillKey,
                mode: "FillKeyMode",
                options: KeyModeOptions
            },
            {
                label: "摄色流转：",
                hotkey: "PickKey",
                value: _SettingsData.pickAndDrawKey,
                mode: "PickKeyMode",
                options: KeyModeOptions
            },
            {
                label: "绘彩巡游：",
                hotkey: "FhpcHk",
                value: _SettingsData.fillOnHoverPickOnClickKey,
                mode: "FhpcHkMode",
                options: KeyModeOptions2
            },
            {
                label: "纵穿千影：",
                hotkey: "DrawVerticalKey",
                value: _SettingsData.DrawVerticalKey,
                mode: "DrawVerticalKeyMode",
                options: KeyModeOptions
            },
            {
                label: "横扫苍茫：",
                hotkey: "DrawHorizontalKey",
                value: _SettingsData.DrawHorizontalKey,
                mode: "DrawHorizontalKeyMode",
                options: KeyModeOptions
            }
        ]

        for key in keys {
            this.instance.AddText(transforms.body_setting labelWidth, key.label)
            if key.HasProp("mode") {
                this.instance.AddHotkey(transforms.body_setting_yp EditWidth " v" key.hotkey, key.value.key)
                this.instance.AddDropDownList(transforms.body_setting_yp DropDownWidth " v" key.mode " R" key.options.Length, key.options)
                    .Value := key.value.mode
            } else this.instance.AddHotkey(transforms.body_setting_yp EditWidth " v" key.hotkey, key.value)
        }

        ; 触发设置
        this.instance.AddText(transforms.body_setting labelWidth, "触发：")
        this.instance.AddDropDownList(transforms.body_setting_yp EditWidth " R2 vTriggerKey", ["左键", "空格"]).Value := Map("LButton", 1, "Space", 2)[_SettingsData.triggerKey]

        ; 其他设置
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2, "其他设置")
        this.instance.SetFont(fonts.body)

        AddSettingRow(body_pos, body_yp, labelWidth, EditWidth, label, varName, value, unit) {
            this.instance.AddText(body_pos labelWidth, label)
            this.instance.AddEdit(body_yp EditWidth " v" varName " Number", value)
            this.instance.AddText(body_yp, unit)
        }
        AddSettingRow(transforms.body_setting, transforms.body_setting_yp, labelWidth, EditWidth, "鼠标移动速度：", "MoveStep", _SettingsData.moveStep, "像素/Tick")
        AddSettingRow(transforms.body_setting, transforms.body_setting_yp, labelWidth, EditWidth, "取色后延迟：", "PickDelay", _SettingsData.pickDelay, "ms填入")
        AddSettingRow(transforms.body_setting, transforms.body_setting_yp, labelWidth, EditWidth, "每次填充延迟：", "DrawDelay", _SettingsData.drawDelay, "ms再次填入")

        this.instance.AddCheckbox(transforms.body_setting labelWidth " vPlaySnd", "涂色播放音效").Value := _SettingsData.playSnd
        this.instance.AddDropDownList(transforms.body_setting_yp DropDownWidth " R2 vPlaySndType", ["曼波~", "Ciallo~"]).Value := _SettingsData.playSndType

        ; 状态提示框设置
        this.instance.AddText(transforms.body_setting labelWidth, "状态提示框位置：")
        this.instance.AddDropDownList(transforms.body_setting_yp " w60 R3 vStatusTip_Horizontal", ["左侧", "中间", "右侧"]).Value := _SettingsData.StatusTip.Horizontal
        this.instance.AddDropDownList(transforms.body_setting_yp " w60 R3 vStatusTip_Vertical", ["顶部", "中间", "底部"]).Value := _SettingsData.StatusTip.Vertical
        this.instance.AddText(transforms.body_setting_yp, "边距")
        this.instance.AddEdit(transforms.body_setting_yp " w40 vStatusTip_margin Number", _SettingsData.StatusTip.margin)
        this.instance.AddText(transforms.body_setting_yp, "像素")

        this.instance.AddText(transforms.body_setting labelWidth, "状态提示框大小：")
        this.instance.AddEdit(transforms.body_setting_yp " w40 vStatusTip_size Number", _SettingsData.StatusTip.size)
        this.instance.AddText(transforms.body_setting_yp, "像素，")
        this.instance.AddText(transforms.body_setting_yp, "描边宽度：")
        this.instance.AddEdit(transforms.body_setting_yp " w40 vStatusTip_stroke_width Number", _SettingsData.StatusTip.strokeWidth)
        this.instance.AddText(transforms.body_setting_yp, "像素")

        this.instance.AddCheckbox(transforms.body_setting " vStatusTip_always_display", "始终显示状态提示框").Value := _SettingsData.StatusTip.alwaysDisplay

        this.instance.AddButton("x30 y550 w455", "保存设置并重启该脚本").OnEvent("Click", (*) => this.SaveAndReload(settingsMap))
    }
    ; 底部按钮
    static AddBottomButtons(settingsMap) {
        ButtonsWidth := " w154"
        this.instance.AddButton("x18" ButtonsWidth, "退出程序").OnEvent("Click", (*) => ExitApp())
        this.instance.AddButton("yp" ButtonsWidth, "打开Wplace").OnEvent("Click", (*) => Run(_SettingsData.wplaceWeb))
        this.instance.AddButton("yp" ButtonsWidth, "确定").OnEvent("Click", (*) => this.OnStartClick(settingsMap))
    }
    ; 更换装饰图片
    static ChangedDecoration() {
        pictures := [
            "image/魔法少女的古士.jpg",
            "image/刻律德拉.jpg",
            "image/霞蝶.jpg",
            "image/迈德漠斯.jpg",
            "image/阿格莱雅.jpg",
            "image/大黑塔.jpg",
            "image/阿那克萨戈拉斯.jpg",
            "image/杨·瓦尔特.jpg",
            "image/丹恒.jpg",
            "image/提安.jpg",
            "image/星期日.jpg",
            "image/姬子.jpg",
            "image/螺丝咕姆.jpg",
            "image/昔涟.jpg",
            "image/卡厄斯兰那.jpg",
            "image/提宝.jpg",
            "image/长夜月.jpg",
            "image/雅辛忒丝.jpg",
            "image/海列屈拉.jpg",
            "image/星.jpg",
            "image/赛法利娅.jpg",
            "image/丹恒•腾荒.jpg",
            "image/迷迷.jpg",
            "image/提宁.jpg",
            "image/穹.jpg",
            "image/三月七.jpg",
            "image/黑天鹅.jpg",
            "image/桃子.jpg",
            "image/昔涟和桃子.jpg",
        ]
        this.instance["Decoration"].Value := pictures[Random(1, pictures.Length)]
    }

    ; ====================================事件=====================================
    static Close() {
        try this.instance.Destroy()
        this.instance := false
    }

    static OnStartClick(settingsMap) {
        if this.HasUnsavedChanges(settingsMap) {
            res := MsgBox("设置已更改但未保存，是否保存？", "提示", "0x23 Owner" this.instance.Hwnd)
            switch res {
                case "Yes":
                    this.SaveAndReload(settingsMap)
                case "No":
                    this.Close()
                case "Cancel":
                    return
            }
        } else {
            this.Close()
        }
    }

    ; ====================================存储=====================================

    static GetSettingsMap() {
        return [
            { data: (&_SettingsData.openThisPageOnStart),         gui: "OpenThisPage" },
            { data: (&_SettingsData.openWplaceOnStart),           gui: "OpenWplace" },
            { data: (&_SettingsData.customUrl),                   gui: "CustomUrl" },
            { data: (&_SettingsData.openCustomOnStart),           gui: "OpenCustom" },
            { data: (&_SettingsData.menuKey),                     gui: "PauseKey" },
            { data: (&_SettingsData.fillKey.key),                 gui: "FillKey" },
            { data: (&_SettingsData.fillKey.mode),                gui: "FillKeyMode" },
            { data: (&_SettingsData.pickAndDrawKey.key),          gui: "PickKey" },
            { data: (&_SettingsData.pickAndDrawKey.mode),         gui: "PickKeyMode" },
            { data: (&_SettingsData.fillOnHoverPickOnClickKey.key), gui: "FhpcHk" },
            { data: (&_SettingsData.fillOnHoverPickOnClickKey.mode), gui: "FhpcHkMode" },
            { data: (&_SettingsData.DrawVerticalKey.key),         gui: "DrawVerticalKey" },
            { data: (&_SettingsData.DrawVerticalKey.mode),        gui: "DrawVerticalKeyMode" },
            { data: (&_SettingsData.DrawHorizontalKey.key),       gui: "DrawHorizontalKey" },
            { data: (&_SettingsData.DrawHorizontalKey.mode),      gui: "DrawHorizontalKeyMode" },
            { data: (&_SettingsData.moveStep),                    gui: "MoveStep" },
            { data: (&_SettingsData.pickDelay),                   gui: "PickDelay" },
            { data: (&_SettingsData.drawDelay),                   gui: "DrawDelay" },
            { data: (&_SettingsData.playSnd),                     gui: "PlaySnd" },
            { data: (&_SettingsData.playSndType),                 gui: "PlaySndType" },
            { data: (&_SettingsData.StatusTip.Horizontal),        gui: "StatusTip_Horizontal" },
            { data: (&_SettingsData.StatusTip.Vertical),          gui: "StatusTip_Vertical" },
            { data: (&_SettingsData.StatusTip.margin),            gui: "StatusTip_margin" },
            { data: (&_SettingsData.StatusTip.size),              gui: "StatusTip_size" },
            { data: (&_SettingsData.StatusTip.strokeWidth),       gui: "StatusTip_stroke_width" },
            { data: (&_SettingsData.StatusTip.alwaysDisplay),     gui: "StatusTip_always_display" }
        ]
    }

    static SaveAndReload(settingsMap) {
        for setting in settingsMap
            %setting.data% := this.instance[setting.gui].Value

        _SettingsData.triggerKey := ["LButton", "Space"][this.instance["TriggerKey"].Value]

        WplaceConfig.save()
        Reload()
    }

    static HasUnsavedChanges(settingsMap) {
        curTriggerKey := ["LButton", "Space"][this.instance["TriggerKey"].Value]

        for setting in settingsMap
            if %setting.data% != this.instance[setting.gui].Value
                return true

        if _SettingsData.triggerKey != curTriggerKey
            return true

        return false
    }
}
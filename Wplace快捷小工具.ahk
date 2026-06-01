#MaxThreads 255
#MaxThreadsPerHotkey 1
KeyMode := {
    heldDown: 1,
    toggle: 2,
    directly: 3
}
class KeyData {
    key := ""
    mode := 0
    __New(key, mode) {
        this.key := key
        this.mode := mode
    }
}
class SettingsData {
    openThisPageOnStart := true
    wplaceWeb := "https://wplace.live/"
    openWplaceOnStart := false
    customUrl := ""
    openCustomOnStart := false
    menuKey := "^Escape"
    fillKey := KeyData("z", KeyMode.heldDown)
    pickAndDrawKey := KeyData("x", KeyMode.directly)
    fillOnHoverPickOnClickKey := KeyData("c", KeyMode.toggle)
    DrawVerticalKey := KeyData("v", KeyMode.directly)
    DrawHorizontalKey := KeyData("h", KeyMode.directly)
    triggerKey := "LButton"
    moveStep := 8
    pickDelay := 100
    drawDelay := 10
    playSnd := false
    playSndType := 1
    StatusTip := {
        horizontal: 1,
        vertical: 3,
        margin: 20,
        size: 100,
        strokeWidth: 5,
        alwaysDisplay: true
    }
}
class WplaceConfig {
    static file := "wplace_config.ini"
    static configs := false
    static Init() {
        this.configs := [
            ["Startup", "OpenThisPage", &_SettingsData.openThisPageOnStart],
            ["Startup", "OpenWplace", &_SettingsData.openWplaceOnStart],
            ["Startup", "CustomUrl", &_SettingsData.customUrl],
            ["Startup", "OpenCustom", &_SettingsData.openCustomOnStart],
            ["Hotkeys", "PauseKey", &_SettingsData.menuKey],
            ["Hotkeys", "FillKey", &_SettingsData.fillKey.key],
            ["Hotkeys", "FillKeyMode", &_SettingsData.fillKey.mode],
            ["Hotkeys", "PickKey", &_SettingsData.pickAndDrawKey.key],
            ["Hotkeys", "PickKeyMode", &_SettingsData.pickAndDrawKey.mode],
            ["Hotkeys", "FillOnHoverPickOnClickKey", &_SettingsData.fillOnHoverPickOnClickKey.key],
            ["Hotkeys", "FillOnHoverPickOnClickKeyMode", &_SettingsData.fillOnHoverPickOnClickKey.mode],
            ["Hotkeys", "DrawVerticalKey", &_SettingsData.DrawVerticalKey.key],
            ["Hotkeys", "DrawVerticalKeyMode", &_SettingsData.DrawVerticalKey.mode],
            ["Hotkeys", "DrawHorizontalKey", &_SettingsData.DrawHorizontalKey.key],
            ["Hotkeys", "DrawHorizontalKeyMode", &_SettingsData.DrawHorizontalKey.mode],
            ["Hotkeys", "TriggerKey", &_SettingsData.triggerKey],
            ["Other", "MoveStep", &_SettingsData.moveStep],
            ["Delay", "PickDelay", &_SettingsData.pickDelay],
            ["Delay", "DrawDelay", &_SettingsData.drawDelay],
            ["Other", "PlaySnd", &_SettingsData.playSnd],
            ["Other", "PlaySndType", &_SettingsData.playSndType],
            ["Other", "StatusTip_Horizontal", &_SettingsData.StatusTip.Horizontal],
            ["Other", "StatusTip_Vertical", &_SettingsData.StatusTip.Vertical],
            ["Other", "StatusTip_Margin", &_SettingsData.StatusTip.margin],
            ["Other", "StatusTip_Size", &_SettingsData.StatusTip.size],
            ["Other", "StatusTip_StrokeWidth", &_SettingsData.StatusTip.strokeWidth],
            ["Other", "StatusTip_AlwaysDisplay", &_SettingsData.StatusTip.alwaysDisplay]
        ]
        this.load()
    }
    static load() {
        for config in this.configs
            try %config[3]% := IniRead(this.file, config[1], config[2])
    }
    static save() {
        for config in this.configs
            IniWrite(%config[3]%, this.file, config[1], config[2])
    }
}
#Requires AutoHotkey v2.0
class FontTools {
    static ScaleFontSize(baseSize) {
        dpiFactor := A_ScreenDPI / 96
        exponent := 0.06
        scaledSize := baseSize * (dpiFactor ** exponent)
        return baseSize
    }
}
class StringTools {
    static HotkeyToString(hotkey) {
        if (!hotkey)
            return "[未设置按键]"
        modMap := Map("^", "Ctrl", "!", "Alt", "+", "Shift", "#", "Win")
        modNames := ""
        mainKey := hotkey
        for modChar, modName in modMap {
            if InStr(mainKey, modChar) {
                modNames .= (modNames != "" ? " + " : "") modName
                mainKey := StrReplace(mainKey, modChar)
            }
        }
        keyName := GetKeyName(mainKey)
        if RegExMatch(keyName, "^[a-z]$")
            keyName := Format("{1:U}", keyName)
        switch keyName {
            case "LButton":
                keyName := "左键"
            case "Space":
                keyName := "空格"
            default:
        }
        if modNames != ""
            return modNames " + " keyName
        else
            return keyName
    }
    static StrJoin(arr, sep := "") {
        result := ""
        for i, v in arr
            result .= (i = 1 ? "" : sep) . v
        return result
    }
}
class IME {
    static SetEnglish() {
        DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)
    }
}
class SettingGui {
    static instance := false
    static settingsMap := false
    static Show() {
        if !this.instance {
            this.instance := Gui()
            this.instance.Title := "Wplace工具 - 菜单                  Ciallo～(∠・ω< )⌒★"
            fonts := {
                h2: "s" FontTools.ScaleFontSize(12) " bold",
                h3: "s" FontTools.ScaleFontSize(11) " bold",
                body: "norm s" FontTools.ScaleFontSize(11)
            }
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
            settingsMap := this.GetSettingsMap()
            this.instance.SetFont(fonts.h2)
            this.instance.AddText(transforms.h1, "作者：洛迪")
            this.instance.SetFont(fonts.body)
            this.instance.AddLink(transforms.h1_yp, ' | <a href="https://space.bilibili.com/418324770">b站主页</a>')
            this.instance.AddLink(transforms.h1_yp, ' | <a href="https://afdian.com/a/luodi">爱发电主页</a>')
            tab := this.instance.AddTab3("x18 y29 w480 h560", ["介绍", "设置", "赞助"])
            tab.UseTab("介绍")
            this.AddIntroContent(tab, fonts, transforms)
            tab.UseTab("设置")
            this.AddSettingsContent(tab, fonts, transforms, settingsMap)
            tab.UseTab("赞助")
            this.instance.AddPicture("x18 y50 w476 h540", "image/QR_code.jpg")
            tab.UseTab()
            this.AddBottomButtons(settingsMap)
            this.instance.AddPicture("x435 y0 w61 h50 vDecoration")
            this.ChangedDecoration()
            tab.OnEvent("Change", (*) => this.ChangedDecoration())
            this.instance.OnEvent("Close", (*) => this.OnStartClick(settingsMap))
            this.instance.Show("w514")
            IME.SetEnglish()
        }
    }
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
            return keyData.mode = KeyMode.directly ? StringTools.HotkeyToString(keyData.key) : StringTools.HotkeyToString(
                _SettingsData.triggerKey)
        }
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2_first, "功能说明：")
        this.instance.SetFont(fonts.body)
        functions :=
            [{
                name: "织色如缕", color: "0071d4",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.fillKey),
                    Format("• 长按{}：对鼠标移动途中连续填充当前颜色", GetKeyName(_SettingsData.fillKey))]
            }, {
                name: "摄色流转", color: "0c8d00",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.pickAndDrawKey),
                    Format("• 点击{}：取色当前颜色后立即填入", GetKeyName(_SettingsData.pickAndDrawKey)),
                    "• 继续长按：滑动到相同颜色时自动填充"]
            }, {
                name: "绘彩巡游", color: "bc0000",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.fillOnHoverPickOnClickKey),
                    "• 始终执行：鼠标滑动到相同颜色时自动填充",
                    Format("• 点击{}：取色当前颜色后立即填入", StringTools.HotkeyToString(_SettingsData.triggerKey)),
                    "• 长按WASD：可控制鼠标移动，使用Shift加速，Ctrl减速"]
            }, {
                name: "纵穿千影", color: "6f00d7",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.DrawVerticalKey),
                    Format("• 按住shift时点击{}：取色当前颜色后立即填充整列相同颜色", GetKeyName(_SettingsData.DrawVerticalKey)),
                    Format("• 点击{}：立即填充整列上次取色的相同颜色", GetKeyName(_SettingsData.DrawVerticalKey))]
            }, {
                name: "横扫苍茫", color: "c8a700",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.DrawHorizontalKey),
                    Format("• 按住shift时点击{}：取色当前颜色后立即填充整行相同颜色", GetKeyName(_SettingsData.DrawHorizontalKey)),
                    Format("• 点击{}：立即填充整行上次取色的相同颜色", GetKeyName(_SettingsData.DrawHorizontalKey))]
            }]
        for func in functions {
            this.instance.SetFont(fonts.h3)
            this.instance.AddText(transforms.h3, func.name).SetFont("c" func.color)
            this.instance.SetFont(fonts.body)
            this.instance.AddPicture("yp w15 h15", StatusGui.ImageFiles[A_Index])
            for desc in func.desc {
                this.instance.AddText(transforms.body, desc)
            }
        }
        this.instance.SetFont(fonts.h3)
        this.instance.AddText(transforms.h3, "其他功能")
        this.instance.SetFont(fonts.body)
        this.instance.AddText(transforms.body, "• 鼠标中键拖动：移动画布（地图）")
        this.instance.AddText(transforms.body, "• 右键擦除颜色，上下左右移动画布（网站原有功能）")
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2, "注意事项：")
        this.instance.SetFont(fonts.body)
        this.instance.AddText(transforms.body, "如果无法启用，请检查是否启用了自动翻译，标题不能被翻译")
        this.instance.AddText(transforms.body, "如果【取色后立即填入该颜色】功能无法触发，请调高取色延迟！")
    }
    static AddSettingsContent(tab, fonts, transforms, settingsMap) {
        labelWidth := " w120"
        EditWidth := " w110"
        DropDownWidth := " w125"
        KeyModeOptions := ["按住时使用模式", "按下后切换模式", "直接触发"]
        KeyModeOptions2 := ["按住时使用模式", "按下后切换模式"]
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2_first, "启动设置")
        this.instance.SetFont(fonts.body)
        this.instance.AddCheckbox(transforms.body_setting " vOpenThisPage", "启动时自动打开本页面").Value := _SettingsData.openThisPageOnStart
        this.instance.AddCheckbox(transforms.body_setting " vOpenWplace", "启动时自动打开Wplace网站").Value := _SettingsData.openWplaceOnStart
        this.instance.AddLink(transforms.body_setting_yp, '<a href="' _SettingsData.wplaceWeb '">' _SettingsData.wplaceWeb '</a>'
        )
        this.instance.AddCheckbox(transforms.body_setting " vOpenCustom", "启动时自动打开自定义程序").Value := _SettingsData.openCustomOnStart
        this.instance.AddEdit(transforms.body_setting_yp " vCustomUrl w160", _SettingsData.customUrl)
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2, "键位设置（为空时表示不使用该功能）")
        this.instance.SetFont(fonts.body)
        keys :=
            [{
                label: "打开菜单：",
                hotkey: "PauseKey",
                value: _SettingsData.menuKey
            }, {
                label: "织色如缕：",
                hotkey: "FillKey",
                value: _SettingsData.fillKey,
                mode: "FillKeyMode",
                options: KeyModeOptions
            }, {
                label: "摄色流转：",
                hotkey: "PickKey",
                value: _SettingsData.pickAndDrawKey,
                mode: "PickKeyMode",
                options: KeyModeOptions
            }, {
                label: "绘彩巡游：",
                hotkey: "FhpcHk",
                value: _SettingsData.fillOnHoverPickOnClickKey,
                mode: "FhpcHkMode",
                options: KeyModeOptions2
            }, {
                label: "纵穿千影：",
                hotkey: "DrawVerticalKey",
                value: _SettingsData.DrawVerticalKey,
                mode: "DrawVerticalKeyMode",
                options: KeyModeOptions
            }, {
                label: "横扫苍茫：",
                hotkey: "DrawHorizontalKey",
                value: _SettingsData.DrawHorizontalKey,
                mode: "DrawHorizontalKeyMode",
                options: KeyModeOptions
            }]
        for key in keys {
            this.instance.AddText(transforms.body_setting labelWidth, key.label)
            if key.HasProp("mode") {
                this.instance.AddHotkey(transforms.body_setting_yp EditWidth " v" key.hotkey, key.value.key)
                this.instance.AddDropDownList(transforms.body_setting_yp DropDownWidth " v" key.mode " R" key.options.Length,
                    key.options)
                .Value := key.value.mode
            } else this.instance.AddHotkey(transforms.body_setting_yp EditWidth " v" key.hotkey, key.value)
        }
        this.instance.AddText(transforms.body_setting labelWidth, "触发：")
        this.instance.AddDropDownList(transforms.body_setting_yp EditWidth " R2 vTriggerKey", ["左键", "空格"]).Value :=
        Map("LButton", 1, "Space", 2)[_SettingsData.triggerKey]
        this.instance.SetFont(fonts.h2)
        this.instance.AddText(transforms.h2, "其他设置")
        this.instance.SetFont(fonts.body)
        AddSettingRow(body_pos, body_yp, labelWidth, EditWidth, label, varName, value, unit) {
            this.instance.AddText(body_pos labelWidth, label)
            this.instance.AddEdit(body_yp EditWidth " v" varName " Number", value)
            this.instance.AddText(body_yp, unit)
        }
        AddSettingRow(transforms.body_setting, transforms.body_setting_yp, labelWidth, EditWidth, "鼠标移动速度：", "MoveStep",
            _SettingsData.moveStep, "像素/Tick")
        AddSettingRow(transforms.body_setting, transforms.body_setting_yp, labelWidth, EditWidth, "取色后延迟：", "PickDelay",
            _SettingsData.pickDelay, "ms填入")
        AddSettingRow(transforms.body_setting, transforms.body_setting_yp, labelWidth, EditWidth, "每次填充延迟：",
            "DrawDelay", _SettingsData.drawDelay, "ms再次填入")
        this.instance.AddCheckbox(transforms.body_setting labelWidth " vPlaySnd", "涂色时播放音效").Value := _SettingsData.playSnd
        this.instance.AddDropDownList(transforms.body_setting_yp DropDownWidth " R2 vPlaySndType", ["曼波~", "Ciallo~"]).Value :=
        _SettingsData.playSndType
        this.instance.AddText(transforms.body_setting labelWidth, "状态提示框位置：")
        this.instance.AddDropDownList(transforms.body_setting_yp " w60 R3 vStatusTip_Horizontal", ["左侧", "中间", "右侧"]).Value :=
        _SettingsData.StatusTip.Horizontal
        this.instance.AddDropDownList(transforms.body_setting_yp " w60 R3 vStatusTip_Vertical", ["顶部", "中间", "底部"]).Value :=
        _SettingsData.StatusTip.Vertical
        this.instance.AddText(transforms.body_setting_yp, "边距")
        this.instance.AddEdit(transforms.body_setting_yp " w40 vStatusTip_margin Number", _SettingsData.StatusTip.margin
        )
        this.instance.AddText(transforms.body_setting_yp, "像素")
        this.instance.AddText(transforms.body_setting labelWidth, "状态提示框大小：")
        this.instance.AddEdit(transforms.body_setting_yp " w40 vStatusTip_size Number", _SettingsData.StatusTip.size)
        this.instance.AddText(transforms.body_setting_yp, "像素，")
        this.instance.AddText(transforms.body_setting_yp, "描边宽度：")
        this.instance.AddEdit(transforms.body_setting_yp " w40 vStatusTip_stroke_width Number", _SettingsData.StatusTip
            .strokeWidth)
        this.instance.AddText(transforms.body_setting_yp, "像素")
        this.instance.AddCheckbox(transforms.body_setting " vStatusTip_always_display", "始终显示状态提示框").Value :=
        _SettingsData.StatusTip.alwaysDisplay
        this.instance.AddButton("x30 y550 w455", "保存设置并重启该脚本").OnEvent("Click", (*) => this.SaveAndReload(settingsMap))
    }
    static AddBottomButtons(settingsMap) {
        ButtonsWidth := " w154"
        this.instance.AddButton("x18" ButtonsWidth, "退出程序").OnEvent("Click", (*) => ExitApp())
        this.instance.AddButton("yp" ButtonsWidth, "打开Wplace").OnEvent("Click", (*) => Run(_SettingsData.wplaceWeb))
        this.instance.AddButton("yp" ButtonsWidth, "确定").OnEvent("Click", (*) => this.OnStartClick(settingsMap))
    }
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
    static GetSettingsMap() {
        return [{
            data: (&_SettingsData.openThisPageOnStart),
            gui: "OpenThisPage"
        }, {
            data: (&_SettingsData.openWplaceOnStart),
            gui: "OpenWplace"
        }, {
            data: (&_SettingsData.customUrl),
            gui: "CustomUrl"
        }, {
            data: (&_SettingsData.openCustomOnStart),
            gui: "OpenCustom"
        }, {
            data: (&_SettingsData.menuKey),
            gui: "PauseKey"
        }, {
            data: (&_SettingsData.fillKey.key),
            gui: "FillKey"
        }, {
            data: (&_SettingsData.fillKey.mode),
            gui: "FillKeyMode"
        }, {
            data: (&_SettingsData.pickAndDrawKey.key),
            gui: "PickKey"
        }, {
            data: (&_SettingsData.pickAndDrawKey.mode),
            gui: "PickKeyMode"
        }, {
            data: (&_SettingsData.fillOnHoverPickOnClickKey.key),
            gui: "FhpcHk"
        }, {
            data: (&_SettingsData.fillOnHoverPickOnClickKey.mode),
            gui: "FhpcHkMode"
        }, {
            data: (&_SettingsData.DrawVerticalKey.key),
            gui: "DrawVerticalKey"
        }, {
            data: (&_SettingsData.DrawVerticalKey.mode),
            gui: "DrawVerticalKeyMode"
        }, {
            data: (&_SettingsData.DrawHorizontalKey.key),
            gui: "DrawHorizontalKey"
        }, {
            data: (&_SettingsData.DrawHorizontalKey.mode),
            gui: "DrawHorizontalKeyMode"
        }, {
            data: (&_SettingsData.moveStep),
            gui: "MoveStep"
        }, {
            data: (&_SettingsData.pickDelay),
            gui: "PickDelay"
        }, {
            data: (&_SettingsData.drawDelay),
            gui: "DrawDelay"
        }, {
            data: (&_SettingsData.playSnd),
            gui: "PlaySnd"
        }, {
            data: (&_SettingsData.playSndType),
            gui: "PlaySndType"
        }, {
            data: (&_SettingsData.StatusTip.Horizontal),
            gui: "StatusTip_Horizontal"
        }, {
            data: (&_SettingsData.StatusTip.Vertical),
            gui: "StatusTip_Vertical"
        }, {
            data: (&_SettingsData.StatusTip.margin),
            gui: "StatusTip_margin"
        }, {
            data: (&_SettingsData.StatusTip.size),
            gui: "StatusTip_size"
        }, {
            data: (&_SettingsData.StatusTip.strokeWidth),
            gui: "StatusTip_stroke_width"
        }, {
            data: (&_SettingsData.StatusTip.alwaysDisplay),
            gui: "StatusTip_always_display"
        }]
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
class StatusGui {
    static instance := false
    static picControl := false
    static lastState := 0
    static lastWinPos := { x: 0, y: 0 }
    static margin := 0
    static actualSize := 0
    static dpiScale := 0
    static visible := false
    static Init() {
        this.instance := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound")
        margin := _SettingsData.StatusTip.strokeWidth
        size := _SettingsData.StatusTip.size
        this.picControl := this.instance.AddPicture("x" margin " y" margin " w" size " h" size, "image/空.jpg")
        guiSize := _SettingsData.StatusTip.size + _SettingsData.StatusTip.strokeWidth * 2
        this.dpiScale := A_ScreenDPI / 96
        this.margin := _SettingsData.StatusTip.margin * this.dpiScale
        this.actualSize := guiSize * this.dpiScale
        this.instance.Show("w" guiSize " h" guiSize " NoActivate Hide")
        if (_SettingsData.StatusTip.alwaysDisplay)
            SetTimer(() {
                if !this.Show()
                    this.Hide
            }, 10)
    }
    static ImageFiles := [
        "image/织色如缕.jpg",
        "image/摄色流转.jpg",
        "image/绘彩巡游.jpg",
        "image/纵穿千影.jpg",
        "image/横扫苍茫.jpg"
    ]
    static Show() {
        winId := WinExist("A")
        if (winId && InStr(WinGetTitle(winId), TitleWindowUsed)) {
            if (this.visible = false) {
                this.instance.Show("NoActivate")
                this.visible := true
            }
            this.UpdatePosition winId
            return true
        }
        return false
    }
    static Hide() {
        if (this.visible = true) {
            this.instance.Hide()
            this.visible := false
        }
    }
    static ChangeState(state) {
        if (state != this.lastState) {
            this.lastState := state
            if (state = 0 && !_SettingsData.StatusTip.alwaysDisplay) {
                this.Hide()
                return
            }
            this.picControl.Value := (state = 0) ? "image/空.jpg" : this.ImageFiles[state]
        }
        this.Show
    }
    static UpdatePosition(winId) {
        WinGetPos(&winX, &winY, &winWidth, &winHeight, winId)
        if winX = this.lastWinPos.x && winY = this.lastWinPos.y
            return
        this.lastWinPos := { x: winX, y: winY }
        static settings := _SettingsData.StatusTip
        margin := this.margin
        actualSize := this.actualSize
        dpiScale := this.dpiScale
        switch settings.Horizontal {
            case 1: picX := winX + margin
            case 2: picX := winX + (winWidth - actualSize) / 2
            default: picX := winX + winWidth - actualSize - margin
        }
        switch settings.Vertical {
            case 1: picY := winY + margin
            case 2: picY := winY + (winHeight - actualSize) / 2
            default: picY := winY + winHeight - actualSize - margin
        }
        picX := Round(picX / dpiScale)
        picY := Round(picY / dpiScale)
        this.instance.Move(picX, picY)
    }
    static ChangeColor(color) => this.instance.BackColor := color
}
class AudioTools {
    static PlayAudioAsync(mFile) {
        DN := this.GetAudioDuration(mFile)
        DllCall("Winmm\mciSendString", "Str", 'Open "' mFile '"', "UInt", 0, "UInt", 0, "UInt", 0)
        DllCall("Winmm\mciSendString", "Str", 'Play "' mFile '" FROM 000 to ' DN, "UInt", 0, "UInt", 0, "UInt", 0)
    }
    static StopPlayback(mFile) {
        DllCall("Winmm\mciSendString", "Str", "Close " mFile, "UInt", 0, "UInt", 0, "UInt", 0)
    }
    static GetAudioDuration(mFile) {
        DN := Buffer(16)
        DllCall("Winmm\mciSendStringW", "Str", 'Open "' mFile '" Alias MP3', "UInt", 0, "UInt", 0, "UInt", 0)
        DllCall("Winmm\mciSendStringW", "Str", "Status MP3 Length", "Ptr", DN.Ptr, "UInt", 16, "UInt", 0)
        DllCall("Winmm\mciSendStringW", "Str", "Close MP3", "UInt", 0, "UInt", 0, "UInt", 0)
        return StrGet(DN)
    }
}
class AudioSound {
    static soundMap := Map(
        "Fill_Begin", [A_ScriptDir "\sounds\曼波↗.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
        "Fill_End", [A_ScriptDir "\sounds\曼波↘.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
        "Pick", [A_ScriptDir "\sounds\哦耶.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
        "Draw", [A_ScriptDir "\sounds\wow~.wav", A_ScriptDir "\sounds\Ciallo~.wav"],
    )
    static PlayAudioAsync(name) {
        if (!_SettingsData.playSnd)
            return
        AudioTools.PlayAudioAsync this.soundMap[name][_SettingsData.playSndType]
    }
}
class ColorTools {
    static GetComplementrayColor(originalHex) {
        complementaryHex := "FFFFFF"
        if (this.IsColor(originalHex)) {
            originalInt := Integer("0x" SubStr(originalHex, 2))
            origR := (originalInt >> 16) & 0xFF
            origG := (originalInt >> 8) & 0xFF
            origB := originalInt & 0xFF
            compR := 255 - origR
            compG := 255 - origG
            compB := 255 - origB
            complementaryInt := (compR << 16) | (compG << 8) | compB
            complementaryHex := Format("{:06X}", complementaryInt)
        }
        return complementaryHex
    }
    static IsColor(color) => RegExMatch(color, "^[0-9A-Fa-f]{6}$")
    static IsColorSimilar(color1, color2, tolerance := 8) {
        r1 := (color1 >> 16) & 0xFF, g1 := (color1 >> 8) & 0xFF, b1 := color1 & 0xFF
        r2 := (color2 >> 16) & 0xFF, g2 := (color2 >> 8) & 0xFF, b2 := color2 & 0xFF
        return Abs(r1 - r2) <= tolerance && Abs(g1 - g2) <= tolerance && Abs(b1 - b2) <= tolerance
    }
    static IsSimilarToAny(color, arr, tolerance := 8) {
        for k, v in arr {
            if this.IsColorSimilar(color, v, tolerance)
                return true
        }
        return false
    }
    static IsSameToAny(color, arr) {
        for k, v in arr {
            if color = v
                return true
        }
        return false
    }
    static GetLineColors(winX, winY, winWidth, winHeight, startX, startY, direction := "H") {
        isH := (direction = "H")
        srcX := isH ? winX : startX
        srcY := isH ? startY : winY
        w := isH ? winWidth : 1
        h := isH ? 1 : winHeight
        hdcScr := DllCall("GetDC", "ptr", 0, "ptr")
        hdcMem := DllCall("CreateCompatibleDC", "ptr", hdcScr, "ptr")
        hbm := DllCall("CreateCompatibleBitmap", "ptr", hdcScr, "int", w, "int", h, "ptr")
        DllCall("SelectObject", "ptr", hdcMem, "ptr", hbm)
        DllCall("BitBlt", "ptr", hdcMem, "int", 0, "int", 0, "int", w, "int", h
            , "ptr", hdcScr, "int", srcX, "int", srcY, "uint", 0xCC0020)
        colors := []
        loop (isH ? winWidth : winHeight) {
            lx := isH ? (A_Index - 1) : 0
            ly := isH ? 0 : (A_Index - 1)
            c := DllCall("GetPixel", "ptr", hdcMem, "int", lx, "int", ly, "uint")
            r := c & 0xFF, g := (c >> 8) & 0xFF, b := (c >> 16) & 0xFF
            colors.Push(Format("0x{:02X}{:02X}{:02X}", r, g, b))
        }
        DllCall("DeleteObject", "ptr", hbm)
        DllCall("DeleteDC", "ptr", hdcMem)
        DllCall("ReleaseDC", "ptr", 0, "ptr", hdcScr)
        return colors
    }
}
class ActionLogic {
    static MouseWinActivate() {
        MouseGetPos , , &winId
        if WinExist("A") != winId
            WinActivate("ahk_id " winId)
    }
    static Fill(key) {
        this.MouseWinActivate
        SendEvent("{Space down}")
        AudioSound.PlayAudioAsync("Fill_Begin")
        KeyWait(key)
        SendEvent("{Space up}")
        AudioSound.PlayAudioAsync("Fill_End")
    }
    static lastPickColor := false
    static PickAndDraw(key, drawLast := true) {
        this.MouseWinActivate
        MouseGetPos &mx, &my
        pixelColor := PixelGetColor(mx, my)
        if ColorTools.IsSimilarToAny(pixelColor, ["0xb1c3eb", "0xc4d6fe", "0x5f7199", "0xfaf7f5", "0x959290",
            "0xe7e4e2"], 4) ||
        ColorTools.IsSameToAny(pixelColor, ["0xf8f4f0", "0x9ebdff"])
            return
        if this.lastPickColor != pixelColor {
            BlockInput "MouseMove"
            Send("i")
            SendEvent("{LButton}")
            Sleep(_SettingsData.pickDelay)
            SendEvent("{Space}")
            BlockInput "MouseMoveOff"
            this.lastPickColor := pixelColor
            StatusGui.ChangeColor(pixelColor)
        }
        else {
            BlockInput "MouseMove"
            SendEvent("{Space}")
            BlockInput "MouseMoveOff"
        }
        AudioSound.PlayAudioAsync("Pick")
        if (drawLast)
            this.DrawLastColor((*) => GetKeyState(key, "P"))
        Sleep(1)
    }
    static DrawLastColor(ShouldContinue) {
        canDraw := false
        static lastX := -1, lastY := -1
        while ShouldContinue() {
            MouseGetPos &mx, &my
            dx := 0, dy := 0
            step := _SettingsData.moveStep
            if GetKeyState("w", "P")
                dy -= step
            if GetKeyState("s", "P")
                dy += step
            if GetKeyState("a", "P")
                dx -= step
            if GetKeyState("d", "P")
                dx += step
            if (dx || dy) {
                if GetKeyState("Shift", "P")
                    dx *= 2, dy *= 2
                else if GetKeyState("Control", "P")
                    dx /= 2, dy /= 2
                MouseMove mx + dx, my + dy, 0
                mx += dx, my += dy
            }
            if (mx = lastX && my = lastY) {
                continue
            }
            pixelColor := PixelGetColor(mx, my)
            if (canDraw && pixelColor = this.lastPickColor) {
                BlockInput "MouseMove"
                Send "{Space}"
                BlockInput "MouseMoveOff"
                canDraw := false
                AudioSound.PlayAudioAsync("Draw")
            }
            else if (!canDraw && pixelColor != this.lastPickColor) {
                canDraw := true
            }
            lastX := mx
            lastY := my
        }
    }
    static PickAndDrawLine(direction) {
        this.MouseWinActivate
        BlockInput "MouseMove"
        MouseGetPos &mx, &my
        MouseMove 0, 0, 0
        Sleep 50
        pixelColor := PixelGetColor(mx, my)
        if ColorTools.IsSameToAny(pixelColor, ["0xf8f4f0", "0x9ebdff"]) {
            MouseMove mx, my
            BlockInput "MouseMoveOff"
            return
        }
        MouseMove mx, my, 0
        Send("i")
        this.lastPickColor := pixelColor
        SendEvent("{LButton}")
        Sleep _SettingsData.pickDelay
        StatusGui.ChangeColor(pixelColor)
        AudioSound.PlayAudioAsync("Pick")
        this.DrawLastColorLine(direction, true)
    }
    static DrawLastColorLine(direction, justPicked := false) {
        MouseGetPos &mx, &my
        target := this.lastPickColor
        if justPicked {
            SendEvent("{Space}")
            Sleep _SettingsData.drawDelay
        }
        else {
            this.MouseWinActivate
            BlockInput "MouseMove"
            MouseMove 0, 0, 0
            Sleep 50
            if PixelGetColor(mx, my) = target {
                MouseMove mx, my, 0
                SendEvent("{Space}")
                Sleep _SettingsData.drawDelay
            }
        }
        winId := WinExist("A")
        WinGetPos &wx, &wy, &ww, &wh, winId
        if (mx < wx || mx >= wx + ww || my < wy || my >= wy + wh) {
            BlockInput "MouseMoveOff"
            return
        }
        isH := (direction = "H")
        colors := ColorTools.GetLineColors(wx, wy, ww, wh, mx, my, direction)
        idx := isH ? (mx - wx) : (my - wy)
        initialColor := colors[idx + 1]
        points := []
        inSeg := false
        len := isH ? ww : wh
        loop len {
            i := A_Index - 1
            col := colors[A_Index]
            pos := isH ? (wx + i) : (wy + i)
            if (col = target) {
                if (!inSeg) {
                    start := pos
                    inSeg := true
                }
            } else if (inSeg) {
                end := pos - 1
                initialPosVal := isH ? mx : my
                if (!(start <= initialPosVal && initialPosVal <= end && initialColor = target)) {
                    points.Push(isH ? [start, my] : [mx, start])
                }
                inSeg := false
            }
        }
        if (inSeg) {
            end := isH ? (wx + len - 1) : (wy + len - 1)
            initialPosVal := isH ? mx : my
            if (!(start <= initialPosVal && initialPosVal <= end && initialColor = target)) {
                points.Push(isH ? [start, my] : [mx, start])
            }
        }
        if (!points.Length) {
            MouseMove mx, my, 0
            BlockInput "MouseMoveOff"
            return
        }
        for p in points {
            MouseMove p[1], p[2], 0
            SendEvent("{Space}")
            Sleep _SettingsData.drawDelay
        }
        AudioSound.PlayAudioAsync("Draw")
        MouseMove mx, my, 0
        BlockInput "MouseMoveOff"
    }
    static Drag(key) {
        MouseGetPos(&startX, &startY)
        isDragging := false
        dragThreshold := 3
        while GetKeyState(key, "P") {
            MouseGetPos(&currentX, &currentY)
            if !isDragging && (Abs(currentX - startX) > dragThreshold || Abs(currentY - startY) > dragThreshold) {
                isDragging := true
                SendEvent("{LButton Down}")
            }
            Sleep(10)
        }
        if isDragging {
            SendEvent("{LButton Up}")
        }
    }
}
class HotkeyTools {
    static IsComboPressed(comboStr, mode := "P") {
        modifiers := Map("^", "Ctrl", "!", "Alt", "+", "Shift", "#", "Win")
        mainKey := comboStr
        for symbol, keyName in modifiers {
            if InStr(comboStr, symbol) {
                if !GetKeyState(keyName, mode)
                    return false
                mainKey := StrReplace(mainKey, symbol)
            }
        }
        return GetKeyState(mainKey, mode)
    }
    static WaitForComboRelease(comboStr) {
        mainKey := comboStr
        modifiers := ["^", "!", "+", "#"]
        for modifier in modifiers {
            mainKey := StrReplace(mainKey, modifier)
        }
        KeyWait mainKey
    }
}
global _SettingsData := SettingsData()
WplaceConfig.Init()
try A_TrayMenu.Delete("&Pause Script")
A_TrayMenu.Insert("1&", "设置(&S)", (*) => SettingGui.Show())
try A_TrayMenu.Rename("&Suspend Hotkeys", "暂停(&P)")
try A_TrayMenu.Rename("E&xit", "退出(&X)")
TitleWindowUsed := "Wplace - Paint the world"
IsWplaceWindow() {
    MouseGetPos , , &winId
    if (winId) {
        title := WinGetTitle(winId)
        return InStr(title, TitleWindowUsed)
    }
    else return false
}
State := {
    Normal: 0,
    Fill: 1,
    PickAndDraw: 2,
    FillOnHoverPickOnClick: 3,
    DrawVertical: 4,
    DrawHorizontal: 5
}
_state := State.Normal
SwitchState(newState) {
    global _state := newState
    StatusGui.ChangeState newState
}
SwitchState_KeyHeldDown(newState, key) {
    global _state
    oldState := _state
    SwitchState newState
    HotkeyTools.WaitForComboRelease key
    SwitchState oldState
}
SwitchState_KeyDown(newState) {
    global _state
    if _state = newState {
        SwitchState State.Normal
        return false
    }
    SwitchState newState
    return true
}
RegisterModeHotkeys(modeObj, stateEnum, actionFunc, actionPickFunc := unset) {
    if !modeObj.key
        return
    trigger := _SettingsData.triggerKey
    switch modeObj.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(modeObj.key, (*) => SwitchState_KeyHeldDown(stateEnum, modeObj.key))
            HotIf (*) => IsWplaceWindow() && _state = stateEnum
            Hotkey("*" trigger, (*) => actionFunc())
            if IsSet(actionPickFunc)
                Hotkey("+" trigger, (*) => actionPickFunc())
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(modeObj.key, (*) => SwitchState_KeyDown(stateEnum))
            HotIf (*) => IsWplaceWindow() && _state = stateEnum
            Hotkey("*" trigger, (*) => actionFunc())
            if IsSet(actionPickFunc)
                Hotkey("+" trigger, (*) => actionPickFunc())
        case KeyMode.directly:
            HotIf (*) => IsWplaceWindow()
            Hotkey("*" modeObj.key, (*) {
                StatusGui.ChangeState(stateEnum)
                actionFunc(modeObj.key)
            })
            Hotkey("*" modeObj.key " up", (*) => StatusGui.ChangeState(_state))
            if IsSet(actionPickFunc) {
                Hotkey("+" modeObj.key, (*) {
                    StatusGui.ChangeState(stateEnum)
                    actionPickFunc(modeObj.key)
                })
                Hotkey("+" modeObj.key " up", (*) => StatusGui.ChangeState(_state))
            }
    }
}
RegisterFillOnHoverPickOnClick() {
    if !_SettingsData.fillOnHoverPickOnClickKey.key
        return
    key := _SettingsData.fillOnHoverPickOnClickKey.key
    trigger := _SettingsData.triggerKey
    switch _SettingsData.fillOnHoverPickOnClickKey.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(key, (*) {
                oldState := _state
                SwitchState State.FillOnHoverPickOnClick
                ActionLogic.DrawLastColor((*) {
                    if GetKeyState(key, "P")
                        return true
                    SwitchState oldState
                    return false
                })
            })
            HotIf (*) => IsWplaceWindow() && _state = State.FillOnHoverPickOnClick
            Hotkey("*" trigger, (*) => ActionLogic.PickAndDraw(trigger, false))
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(key, (*) {
                if SwitchState_KeyDown(State.FillOnHoverPickOnClick)
                    SetTimer (*) => ActionLogic.DrawLastColor((*) {
                        if !WinActive(TitleWindowUsed) {
                            SwitchState_KeyDown(State.Normal)
                            return false
                        }
                        return _state = State.FillOnHoverPickOnClick
                    }), -1
            })
            HotIf (*) => IsWplaceWindow() && _state = State.FillOnHoverPickOnClick
            Hotkey("*" trigger, (*) => ActionLogic.PickAndDraw(trigger, false))
    }
}
if _SettingsData.menuKey
    Hotkey(_SettingsData.menuKey, (*) => SettingGui.Show())
RegisterModeHotkeys(_SettingsData.fillKey, State.Fill,
    (k := _SettingsData.triggerKey) => ActionLogic.Fill(k))
RegisterModeHotkeys(_SettingsData.pickAndDrawKey, State.PickAndDraw,
    (k := _SettingsData.triggerKey) => ActionLogic.PickAndDraw(k, true))
RegisterModeHotkeys(_SettingsData.DrawVerticalKey, State.DrawVertical,
    (*) => ActionLogic.DrawLastColorLine("V"),
    (*) => ActionLogic.PickAndDrawLine("V"))
RegisterModeHotkeys(_SettingsData.DrawHorizontalKey, State.DrawHorizontal,
    (*) => ActionLogic.DrawLastColorLine("H"),
    (*) => ActionLogic.PickAndDrawLine("H"))
RegisterFillOnHoverPickOnClick()
HotIf (*) => WinActive(TitleWindowUsed)
Hotkey("*w", (*) => "")
Hotkey("*a", (*) => "")
Hotkey("*s", (*) => "")
Hotkey("*d", (*) => "")
HotIf (*) => IsWplaceWindow()
Hotkey("MButton", (*) => ActionLogic.Drag("MButton"))
if _SettingsData.openWplaceOnStart
    Run(_SettingsData.wplaceWeb)
if _SettingsData.openCustomOnStart && _SettingsData.customUrl != ""
    Run(_SettingsData.customUrl)
if _SettingsData.openThisPageOnStart
    SettingGui.Show()
StatusGui.Init()
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"
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
    pickAndDrawKey := KeyData("x", KeyMode.heldDown)
    fillOnHoverPickOnClickKey := KeyData("c", KeyMode.toggle)
    DrawVerticalKey := KeyData("v", KeyMode.toggle)
    DrawHorizontalKey := KeyData("h", KeyMode.toggle)
    triggerKey := "LButton"
    moveStep := 2
    pickDelay := 200
    drawDelay := 10
    playSnd := false
    playSndType := 1
    StatusTip := {
        horizontal: 3,
        vertical: 1,
        margin: 20,
        size: 100,
        strokeWidth: 5
    }
}
class WplaceConfig {
    static file := "wplace_config.ini"
    static load() {
        try {
            this.TryRead(&_SettingsData.openThisPageOnStart, "Startup", "OpenThisPage")
            this.TryRead(&_SettingsData.openWplaceOnStart, "Startup", "OpenWplace")
            this.TryRead(&_SettingsData.customUrl, "Startup", "CustomUrl")
            this.TryRead(&_SettingsData.openCustomOnStart, "Startup", "OpenCustom")
            this.TryRead(&_SettingsData.menuKey, "Hotkeys", "PauseKey")
            this.TryRead(&_SettingsData.fillKey.key, "Hotkeys", "FillKey")
            this.TryRead(&_SettingsData.fillKey.mode, "Hotkeys", "FillKeyMode")
            this.TryRead(&_SettingsData.pickAndDrawKey.key, "Hotkeys", "PickKey")
            this.TryRead(&_SettingsData.pickAndDrawKey.mode, "Hotkeys", "PickKeyMode")
            this.TryRead(&_SettingsData.fillOnHoverPickOnClickKey.key, "Hotkeys", "FillOnHoverPickOnClickKey")
            this.TryRead(&_SettingsData.fillOnHoverPickOnClickKey.mode, "Hotkeys", "FillOnHoverPickOnClickKeyMode")
            this.TryRead(&_SettingsData.DrawVerticalKey.key, "Hotkeys", "DrawVerticalKey")
            this.TryRead(&_SettingsData.DrawVerticalKey.mode, "Hotkeys", "DrawVerticalKeyMode")
            this.TryRead(&_SettingsData.DrawHorizontalKey.key, "Hotkeys", "DrawHorizontalKey")
            this.TryRead(&_SettingsData.DrawHorizontalKey.mode, "Hotkeys", "DrawHorizontalKeyMode")
            this.TryRead(&_SettingsData.triggerKey, "Hotkeys", "TriggerKey")
            this.TryRead(&_SettingsData.moveStep, "Other", "MoveStep")
            this.TryRead(&_SettingsData.pickDelay, "Delay", "PickDelay")
            this.TryRead(&_SettingsData.drawDelay, "Delay", "DrawDelay")
            this.TryRead(&_SettingsData.playSnd, "Other", "PlaySnd")
            this.TryRead(&_SettingsData.playSndType, "Other", "PlaySndType")
            this.TryRead(&_SettingsData.StatusTip.Horizontal, "Other", "StatusTip_Horizontal")
            this.TryRead(&_SettingsData.StatusTip.Vertical, "Other", "StatusTip_Vertical")
            this.TryRead(&_SettingsData.StatusTip.margin, "Other", "StatusTip_Margin")
            this.TryRead(&_SettingsData.StatusTip.size, "Other", "StatusTip_Size")
            this.TryRead(&_SettingsData.StatusTip.strokeWidth, "Other", "StatusTip_StrokeWidth")
        }
    }
    static TryRead(&data, Section, Key) {
        try {
            data := IniRead(WplaceConfig.file, Section, Key)
        }
    }
    static save() {
        IniWrite(_SettingsData.openThisPageOnStart, WplaceConfig.file, "Startup", "OpenThisPage")
        IniWrite(_SettingsData.openWplaceOnStart, WplaceConfig.file, "Startup", "OpenWplace")
        IniWrite(_SettingsData.customUrl, WplaceConfig.file, "Startup", "CustomUrl")
        IniWrite(_SettingsData.openCustomOnStart, WplaceConfig.file, "Startup", "OpenCustom")
        IniWrite(_SettingsData.menuKey, WplaceConfig.file, "Hotkeys", "PauseKey")
        IniWrite(_SettingsData.fillKey.key, WplaceConfig.file, "Hotkeys", "FillKey")
        IniWrite(_SettingsData.fillKey.mode, WplaceConfig.file, "Hotkeys", "FillKeyMode")
        IniWrite(_SettingsData.pickAndDrawKey.key, WplaceConfig.file, "Hotkeys", "PickKey")
        IniWrite(_SettingsData.pickAndDrawKey.mode, WplaceConfig.file, "Hotkeys", "PickKeyMode")
        IniWrite(_SettingsData.fillOnHoverPickOnClickKey.key, WplaceConfig.file, "Hotkeys", "FillOnHoverPickOnClickKey"
        )
        IniWrite(_SettingsData.fillOnHoverPickOnClickKey.mode, WplaceConfig.file, "Hotkeys",
            "FillOnHoverPickOnClickKeyMode")
        IniWrite(_SettingsData.DrawVerticalKey.key, WplaceConfig.file, "Hotkeys", "DrawVerticalKey")
        IniWrite(_SettingsData.DrawVerticalKey.mode, WplaceConfig.file, "Hotkeys", "DrawVerticalKeyMode")
        IniWrite(_SettingsData.DrawHorizontalKey.key, WplaceConfig.file, "Hotkeys", "DrawHorizontalKey")
        IniWrite(_SettingsData.DrawHorizontalKey.mode, WplaceConfig.file, "Hotkeys", "DrawHorizontalKeyMode")
        IniWrite(_SettingsData.triggerKey, WplaceConfig.file, "Hotkeys", "TriggerKey")
        IniWrite(_SettingsData.moveStep, WplaceConfig.file, "Other", "MoveStep")
        IniWrite(_SettingsData.pickDelay, WplaceConfig.file, "Delay", "PickDelay")
        IniWrite(_SettingsData.drawDelay, WplaceConfig.file, "Delay", "DrawDelay")
        IniWrite(_SettingsData.playSnd, WplaceConfig.file, "Other", "PlaySnd")
        IniWrite(_SettingsData.playSndType, WplaceConfig.file, "Other", "PlaySndType")
        IniWrite(_SettingsData.StatusTip.Horizontal, WplaceConfig.file, "Other", "StatusTip_Horizontal")
        IniWrite(_SettingsData.StatusTip.Vertical, WplaceConfig.file, "Other", "StatusTip_Vertical")
        IniWrite(_SettingsData.StatusTip.margin, WplaceConfig.file, "Other", "StatusTip_Margin")
        IniWrite(_SettingsData.StatusTip.size, WplaceConfig.file, "Other", "StatusTip_Size")
        IniWrite(_SettingsData.StatusTip.strokeWidth, WplaceConfig.file, "Other", "StatusTip_StrokeWidth")
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
    static Show() {
        if !this.instance {
            this.instance := Gui()
            this.instance.Title := "Wplace工具 - 菜单                  Ciallo～(∠・ω< )⌒★"
            fonts := Map(
                "h2", "s" FontTools.ScaleFontSize(12) " bold",
                "h3", "s" FontTools.ScaleFontSize(11) " bold",
                "body", "norm s" FontTools.ScaleFontSize(11)
            )
            positions := Map(
                "h2_first", "x30 y60",
                "h2", "x30 y+5",
                "h3", "x40 y+5",
                "body", "x50 y+3"
            )
            this.instance.SetFont(fonts["h2"])
            this.instance.AddText("x30", "作者：洛迪")
            this.instance.SetFont(fonts["body"])
            this.instance.AddLink("yp", ' | <a href="https://space.bilibili.com/418324770">b站主页</a>')
            this.instance.AddLink("yp", ' | <a href="https://afdian.com/a/luodi">爱发电主页</a>')
            tab := this.instance.AddTab3("x18 y+10 w480 h520", ["介绍", "设置", "赞助"])
            tab.UseTab("介绍")
            this.AddIntroContent(tab, fonts, positions)
            tab.UseTab("设置")
            this.AddSettingsContent(tab, fonts, positions)
            tab.UseTab("赞助")
            this.instance.AddPicture("x18 y50 w476 h520", "image/QR_code.jpg")
            tab.UseTab()
            this.AddBottomButtons()
            this.instance.Show("w514")
            IME.SetEnglish()
        }
    }
    static AddIntroContent(tab, fonts, positions) {
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
        this.instance.SetFont(fonts["h2"])
        this.instance.AddText(positions["h2_first"], "功能说明：")
        this.instance.SetFont(fonts["body"])
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
                    Format("• 按住shift时点击{}：取色当前颜色后立即填充整列相同颜色", StringTools.HotkeyToString(_SettingsData.triggerKey)),
                    Format("• 点击{}：立即填充整列上次取色的相同颜色", StringTools.HotkeyToString(_SettingsData.triggerKey))]
            }, {
                name: "横扫苍茫", color: "c8a700",
                desc: [
                    GetDescribeByKeyMode(_SettingsData.DrawHorizontalKey),
                    Format("• 按住shift时点击{}：取色当前颜色后立即填充整行相同颜色", StringTools.HotkeyToString(_SettingsData.triggerKey)),
                    Format("• 点击{}：立即填充整行上次取色的相同颜色", StringTools.HotkeyToString(_SettingsData.triggerKey))]
            }]
        for func in functions {
            this.instance.SetFont(fonts["h3"])
            this.instance.AddText(positions["h3"], func.name).SetFont("c" func.color)
            this.instance.SetFont(fonts["body"])
            this.instance.AddPicture("yp w15 h15", StatusGui.ImageFiles[A_Index])
            for desc in func.desc {
                this.instance.AddText(positions["body"], desc)
            }
        }
        this.instance.SetFont(fonts["h3"])
        this.instance.AddText(positions["h3"], "其他功能")
        this.instance.SetFont(fonts["body"])
        this.instance.AddText(positions["body"], "• 鼠标中键拖动：移动画布（地图）")
        this.instance.AddText(positions["body"], "• 右键擦除颜色，上下左右移动画布（网站原有功能）")
        this.instance.SetFont(fonts["h2"])
        this.instance.AddText(positions["h2"], "注意事项：")
        this.instance.SetFont(fonts["body"])
        this.instance.AddText(positions["body"], "如果无法启用，请检查是否启用了自动翻译，标题被翻译会无法使用")
        this.instance.AddText(positions["body"], "如果【取色后立即填入该颜色】功能无法触发，请调高取色延迟！")
    }
    static AddSettingsContent(tab, fonts, positions) {
        body_pos := positions["body"] " h20"
        body_yp := "h20 yp"
        labelWidth := " w120"
        EditWidth := " w110"
        DropDownWidth := " w125"
        KeyModeOptions := ["按住时使用模式", "按下后切换模式", "直接触发"]
        KeyModeOptions2 := ["按住时使用模式", "按下后切换模式"]
        this.instance.SetFont(fonts["h2"])
        this.instance.AddText(positions["h2_first"], "启动设置")
        this.instance.SetFont(fonts["body"])
        this.instance.AddCheckbox(body_pos " vOpenThisPage", "启动时自动打开本页面").Value := _SettingsData.openThisPageOnStart
        this.instance.AddCheckbox(body_pos " vOpenWplace", "启动时自动打开Wplace网站").Value := _SettingsData.openWplaceOnStart
        this.instance.AddLink(body_yp, '<a href="' _SettingsData.wplaceWeb '">' _SettingsData.wplaceWeb '</a>')
        this.instance.AddCheckbox(body_pos " h25 vOpenCustom", "启动时自动打开自定义程序").Value := _SettingsData.openCustomOnStart
        this.instance.AddEdit(body_yp " vCustomUrl w160", _SettingsData.customUrl)
        this.instance.SetFont(fonts["h2"])
        this.instance.AddText(positions["h2"], "键位设置（为空时表示不使用该功能）")
        this.instance.SetFont(fonts["body"])
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
            this.instance.AddText(body_pos labelWidth, key.label)
            if key.HasProp("mode") {
                this.instance.AddHotkey(body_yp EditWidth " v" key.hotkey, key.value.key)
                this.instance.AddDropDownList(body_yp DropDownWidth " v" key.mode " R" key.options.Length, key.options)
                .Value := key.value.mode
            } else this.instance.AddHotkey(body_yp EditWidth " v" key.hotkey, key.value)
        }
        this.instance.AddText(body_pos labelWidth, "触发：")
        this.instance.AddDropDownList(body_yp EditWidth " R2 vTriggerKey", ["左键", "空格"]).Value := Map("LButton", 1,
            "Space", 2)[_SettingsData.triggerKey]
        this.instance.SetFont(fonts["h2"])
        this.instance.AddText(positions["h2"], "其他设置")
        this.instance.SetFont(fonts["body"])
        this.AddSettingRow(body_pos, body_yp, labelWidth, EditWidth, "鼠标移动速度：", "MoveStep", _SettingsData.moveStep,
            "像素/Tick")
        this.AddSettingRow(body_pos, body_yp, labelWidth, EditWidth, "取色后延迟：", "PickDelay", _SettingsData.pickDelay,
            "ms填入")
        this.AddSettingRow(body_pos, body_yp, labelWidth, EditWidth, "每次填充延迟：", "DrawDelay", _SettingsData.drawDelay,
            "ms再次填入")
        this.instance.AddCheckbox(body_pos labelWidth " vPlaySnd", "涂色时播放音效").Value := _SettingsData.playSnd
        this.instance.AddDropDownList(body_yp DropDownWidth " R2 vPlaySndType", ["曼波~", "Ciallo~"]).Value :=
        _SettingsData.playSndType
        this.AddStatusTipSettings(body_pos, body_yp, labelWidth, EditWidth, DropDownWidth)
        this.instance.AddButton("x30 y510 w455", "保存设置并重启该脚本").OnEvent("Click", (*) => this.SaveAndReload())
    }
    static AddSettingRow(body_pos, body_yp, labelWidth, EditWidth, label, varName, value, unit) {
        this.instance.AddText(body_pos labelWidth, label)
        this.instance.AddEdit(body_yp EditWidth " v" varName " Number", value)
        this.instance.AddText(body_yp, unit)
    }
    static AddStatusTipSettings(body_pos, body_yp, labelWidth, EditWidth, DropDownWidth) {
        this.instance.AddText(body_pos labelWidth, "状态提示框位置：")
        this.instance.AddDropDownList(body_yp " w60 R3 vStatusTip_Horizontal", ["左侧", "中间", "右侧"]).Value :=
        _SettingsData.StatusTip.Horizontal
        this.instance.AddDropDownList(body_yp " w60 R3 vStatusTip_Vertical", ["顶部", "中间", "底部"]).Value := _SettingsData
        .StatusTip.Vertical
        this.instance.AddText(body_yp, "边距")
        this.instance.AddEdit(body_yp " w40 vStatusTip_margin Number", _SettingsData.StatusTip.margin)
        this.instance.AddText(body_yp, "像素")
        this.instance.AddText(body_pos labelWidth, "状态提示框大小：")
        this.instance.AddEdit(body_yp " w40 vStatusTip_size Number", _SettingsData.StatusTip.size)
        this.instance.AddText(body_yp, "像素，")
        this.instance.AddText(body_yp, "描边宽度：")
        this.instance.AddEdit(body_yp " w40 vStatusTip_stroke_width Number", _SettingsData.StatusTip.strokeWidth)
        this.instance.AddText(body_yp, "像素")
    }
    static AddBottomButtons() {
        ButtonsWidth := " w154"
        this.instance.AddButton("x18" ButtonsWidth, "退出程序").OnEvent("Click", (*) => ExitApp())
        this.instance.AddButton("yp" ButtonsWidth, "打开Wplace").OnEvent("Click", (*) => Run(_SettingsData.wplaceWeb))
        this.instance.AddButton("yp" ButtonsWidth, "确定").OnEvent("Click", (*) => this.OnStartClick())
        this.instance.OnEvent("Close", (*) => this.OnStartClick())
    }
    static Close() {
        try this.instance.Destroy()
        this.instance := false
    }
    static SaveAndReload() {
        if !this.instance["PickDelay"].Value ||
            !this.instance["MoveStep"].Value {
            MsgBox("请输入一个正整数！", "错误", "0x10 Owner" this.instance.Hwnd)
            return
        }
        _SettingsData.openThisPageOnStart := this.instance["OpenThisPage"].Value
        _SettingsData.openWplaceOnStart := this.instance["OpenWplace"].Value
        _SettingsData.customUrl := this.instance["CustomUrl"].Text
        _SettingsData.openCustomOnStart := this.instance["OpenCustom"].Value
        _SettingsData.menuKey := this.instance["PauseKey"].Value
        _SettingsData.fillKey.key := this.instance["FillKey"].Value
        _SettingsData.fillKey.mode := this.instance["FillKeyMode"].Value
        _SettingsData.pickAndDrawKey.key := this.instance["PickKey"].Value
        _SettingsData.pickAndDrawKey.mode := this.instance["PickKeyMode"].Value
        _SettingsData.fillOnHoverPickOnClickKey.key := this.instance["FhpcHk"].Value
        _SettingsData.fillOnHoverPickOnClickKey.mode := this.instance["FhpcHkMode"].Value
        _SettingsData.DrawVerticalKey.key := this.instance["DrawVerticalKey"].Value
        _SettingsData.DrawVerticalKey.mode := this.instance["DrawVerticalKeyMode"].Value
        _SettingsData.DrawHorizontalKey.key := this.instance["DrawHorizontalKey"].Value
        _SettingsData.DrawHorizontalKey.mode := this.instance["DrawHorizontalKeyMode"].Value
        _SettingsData.triggerKey := ["LButton", "Space"][this.instance["TriggerKey"].Value]
        _SettingsData.moveStep := Integer(this.instance["MoveStep"].Value)
        _SettingsData.pickDelay := Integer(this.instance["PickDelay"].Value)
        _SettingsData.drawDelay := Integer(this.instance["DrawDelay"].Value)
        _SettingsData.playSnd := this.instance["PlaySnd"].Value
        _SettingsData.playSndType := this.instance["PlaySndType"].Value
        _SettingsData.StatusTip.Horizontal := this.instance["StatusTip_Horizontal"].Value
        _SettingsData.StatusTip.Vertical := this.instance["StatusTip_Vertical"].Value
        _SettingsData.StatusTip.margin := this.instance["StatusTip_margin"].Value
        _SettingsData.StatusTip.size := this.instance["StatusTip_size"].Value
        _SettingsData.StatusTip.strokeWidth := this.instance["StatusTip_stroke_width"].Value
        WplaceConfig.save()
        Reload()
    }
    static HasUnsavedChanges() {
        curTriggerKey := ["LButton", "Space"][this.instance["TriggerKey"].Value]
        if _SettingsData.openThisPageOnStart != this.instance["OpenThisPage"].Value ||
            _SettingsData.openWplaceOnStart != this.instance["OpenWplace"].Value ||
            _SettingsData.customUrl != this.instance["CustomUrl"].Text ||
            _SettingsData.openCustomOnStart != this.instance["OpenCustom"].Value ||
            _SettingsData.menuKey != this.instance["PauseKey"].Value ||
            _SettingsData.fillKey.key != this.instance["FillKey"].Value ||
            _SettingsData.fillKey.mode != this.instance["FillKeyMode"].Value ||
            _SettingsData.pickAndDrawKey.key != this.instance["PickKey"].Value ||
            _SettingsData.pickAndDrawKey.mode != this.instance["PickKeyMode"].Value ||
            _SettingsData.fillOnHoverPickOnClickKey.key != this.instance["FhpcHk"].Value ||
            _SettingsData.fillOnHoverPickOnClickKey.mode != this.instance["FhpcHkMode"].Value ||
            _SettingsData.DrawVerticalKey.key != this.instance["DrawVerticalKey"].Value ||
            _SettingsData.DrawVerticalKey.mode != this.instance["DrawVerticalKeyMode"].Value ||
            _SettingsData.DrawHorizontalKey.key != this.instance["DrawHorizontalKey"].Value ||
            _SettingsData.DrawHorizontalKey.mode != this.instance["DrawHorizontalKeyMode"].Value ||
            _SettingsData.triggerKey != curTriggerKey ||
            _SettingsData.moveStep != this.instance["MoveStep"].Value ||
            _SettingsData.pickDelay != this.instance["PickDelay"].Value ||
            _SettingsData.drawDelay != this.instance["DrawDelay"].Value ||
            _SettingsData.playSnd != this.instance["PlaySnd"].Value ||
            _SettingsData.playSndType != this.instance["PlaySndType"].Value ||
            _SettingsData.StatusTip.Horizontal != this.instance["StatusTip_Horizontal"].Value ||
            _SettingsData.StatusTip.Vertical != this.instance["StatusTip_Vertical"].Value ||
            _SettingsData.StatusTip.margin != this.instance["StatusTip_margin"].Value ||
            _SettingsData.StatusTip.size != this.instance["StatusTip_size"].Value ||
            _SettingsData.StatusTip.strokeWidth != this.instance["StatusTip_stroke_width"].Value
            return true
        return false
    }
    static OnStartClick() {
        if this.HasUnsavedChanges() {
            res := MsgBox("设置已更改但未保存，是否保存？", "提示", "0x23 Owner" this.instance.Hwnd)
            switch res {
                case "Yes":
                    this.SaveAndReload()
                case "No":
                    this.Close()
                case "Cancel":
                    return
            }
        } else {
            this.Close()
        }
    }
}
class StatusGui {
    static instance := false
    static picControl := false
    static Init() {
        if (this.instance)
            return
        this.instance := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound")
        margin := _SettingsData.StatusTip.strokeWidth
        size := _SettingsData.StatusTip.size
        this.picControl := this.instance.AddPicture("x" margin " y" margin " w" size " h" size)
    }
    static ImageFiles := [
        "image/织色如缕.png",
        "image/摄色流转.png",
        "image/绘彩巡游.png",
        "image/纵穿千影.png",
        "image/横扫苍茫.png"
    ]
    static Show(state) {
        if (state = 0) {
            this.instance.Hide()
            return
        }
        ImageFiles := this.ImageFiles
        WinGetPos(&winX, &winY, &winWidth, &winHeight, "A")
        size := _SettingsData.StatusTip.size + _SettingsData.StatusTip.strokeWidth * 2
        dpiScale := A_ScreenDPI / 96
        picWidth := size * dpiScale
        picHeight := size * dpiScale
        margin := _SettingsData.StatusTip.margin * dpiScale
        switch _SettingsData.StatusTip.Horizontal {
            case 1:
                picX := winX + margin
            case 2:
                picX := winX + (winWidth - picWidth) / 2
            default:
                picX := winX + winWidth - picWidth - margin
        }
        switch _SettingsData.StatusTip.Vertical {
            case 1:
                picY := winY + margin
            case 2:
                picY := winY + (winHeight - picHeight) / 2
            default:
                picY := winY + winHeight - picHeight - margin
        }
        picX := Round(picX)
        picY := Round(picY)
        this.picControl.Value := ImageFiles[state]
        this.instance.Show("x" picX " y" picY " w" size " h" size " NoActivate")
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
    static PickAndDraw(key, drawLast) {
        this.MouseWinActivate
        MouseGetPos &mouseX, &mouseY
        pixelColor := PixelGetColor(mouseX, mouseY)
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
    }
    static DrawLastColor(ShouldContinue) {
        canDraw := false
        static lastX := -1, lastY := -1
        while ShouldContinue() {
            MouseGetPos &mouseX, &mouseY
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
                MouseMove mouseX + dx, mouseY + dy, 0
                mouseX += dx, mouseY += dy
            }
            if (mouseX = lastX && mouseY = lastY) {
                continue
            }
            pixelColor := PixelGetColor(mouseX, mouseY)
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
            lastX := mouseX
            lastY := mouseY
        }
    }
    static PickAndDrawLine(direction) {
        this.MouseWinActivate
        BlockInput "MouseMove"
        Send("i")
        Sleep(400)
        MouseGetPos &mouseX, &mouseY
        pixelColor := PixelGetColor(mouseX, mouseY)
        if ColorTools.IsSameToAny(pixelColor, ["0xf8f4f0", "0x9ebdff"]) {
            SendEvent("{RButton}")
            BlockInput "MouseMoveOff"
            return
        }
        this.lastPickColor := pixelColor
        SendEvent("{LButton}")
        Sleep(_SettingsData.pickDelay)
        SendEvent("{Space}")
        Sleep _SettingsData.drawDelay
        StatusGui.ChangeColor(pixelColor)
        AudioSound.PlayAudioAsync("Pick")
        this.DrawLastColorLine(direction)
    }
    static DrawLastColorLine(direction) {
        this.MouseWinActivate
        MouseGetPos &mx, &my
        target := this.lastPickColor
        winId := WinExist("A")
        WinGetPos &wx, &wy, &ww, &wh, winId
        if (mx < wx || mx >= wx + ww || my < wy || my >= wy + wh)
            return
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
            BlockInput "MouseMoveOff"
            return
        }
        MouseGetPos &ox, &oy
        BlockInput "MouseMove"
        for p in points {
            MouseMove p[1], p[2], 0
            SendEvent("{Space}")
            Sleep _SettingsData.drawDelay
        }
        BlockInput "MouseMoveOff"
        AudioSound.PlayAudioAsync("Draw")
        MouseMove ox, oy, 0
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
WplaceConfig.load()
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
    StatusGui.Show(newState)
}
SwitchState_KeyHeldDown(newState, key) {
    global _state
    oldState := _state
    SwitchState(newState)
    HotkeyTools.WaitForComboRelease(key)
    SwitchState(oldState)
}
SwitchState_KeyDown(newState) {
    global _state
    if (_state = newState) {
        SwitchState(State.Normal)
        return false
    }
    SwitchState(newState)
    return true
}
if _SettingsData.menuKey
    Hotkey(_SettingsData.menuKey, (*) => SettingGui.Show())
if _SettingsData.fillKey.key
    switch _SettingsData.fillKey.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.fillKey.key, (*) => SwitchState_KeyHeldDown(State.Fill, _SettingsData.fillKey.key))
            HotIf (*) => IsWplaceWindow() && _state = State.Fill
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.Fill(_SettingsData.triggerKey))
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.fillKey.key, (*) => SwitchState_KeyDown(State.Fill))
            HotIf (*) => IsWplaceWindow() && _state = State.Fill
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.Fill(_SettingsData.triggerKey))
        case KeyMode.directly:
            HotIf (*) => IsWplaceWindow()
            Hotkey("*" _SettingsData.fillKey.key, (*) => ActionLogic.Fill(_SettingsData.fillKey.key))
    }
if _SettingsData.pickAndDrawKey.key
    switch _SettingsData.pickAndDrawKey.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.pickAndDrawKey.key, (*) => SwitchState_KeyHeldDown(State.PickAndDraw, _SettingsData.pickAndDrawKey
                .key))
            HotIf (*) => IsWplaceWindow() && _state = State.PickAndDraw
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDraw(_SettingsData.triggerKey, true))
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.pickAndDrawKey.key, (*) => SwitchState_KeyDown(State.PickAndDraw))
            HotIf (*) => IsWplaceWindow() && _state = State.PickAndDraw
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDraw(_SettingsData.triggerKey, true))
        case KeyMode.directly:
            HotIf (*) => IsWplaceWindow()
            Hotkey("*" _SettingsData.pickAndDrawKey.key, (*) => ActionLogic.PickAndDraw(_SettingsData.pickAndDrawKey.key,
                true))
    }
if _SettingsData.fillOnHoverPickOnClickKey.key
    switch _SettingsData.fillOnHoverPickOnClickKey.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.fillOnHoverPickOnClickKey.key, (*) => Switch_FillOnHoverPickOnClick_KeyHeldDown())
            Switch_FillOnHoverPickOnClick_KeyHeldDown() {
                global _state
                oldState := _state
                SwitchState State.FillOnHoverPickOnClick
                ActionLogic.DrawLastColor((*) => End_FillOnHoverPickOnClick_KeyUp())
                End_FillOnHoverPickOnClick_KeyUp() {
                    if GetKeyState(_SettingsData.fillOnHoverPickOnClickKey.key, "P")
                        return true
                    SwitchState oldState
                    return false
                }
            }
            HotIf (*) => IsWplaceWindow() && _state = State.FillOnHoverPickOnClick
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDraw(_SettingsData.triggerKey, false))
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.fillOnHoverPickOnClickKey.key, (*) => Switch_FillOnHoverPickOnClick_KeyDown())
            Switch_FillOnHoverPickOnClick_KeyDown() {
                if SwitchState_KeyDown(State.FillOnHoverPickOnClick)
                    SetTimer (*) => ActionLogic.DrawLastColor((*) => End_FillOnHoverPickOnClick_LeaveWin()), -1
                End_FillOnHoverPickOnClick_LeaveWin() {
                    if !WinActive(TitleWindowUsed) {
                        SwitchState_KeyDown(State.Normal)
                        return false
                    }
                    return _state = State.FillOnHoverPickOnClick
                }
            }
            HotIf (*) => IsWplaceWindow() && _state = State.FillOnHoverPickOnClick
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDraw(_SettingsData.triggerKey, false))
    }
if _SettingsData.DrawVerticalKey.key
    switch _SettingsData.DrawVerticalKey.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.DrawVerticalKey.key, (*) => SwitchState_KeyHeldDown(State.DrawVertical, _SettingsData.DrawVerticalKey
                .key))
            HotIf (*) => IsWplaceWindow() && _state = State.DrawVertical
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.DrawLastColorLine("V"))
            Hotkey("+" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDrawLine("V"))
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.DrawVerticalKey.key, (*) => SwitchState_KeyDown(State.DrawVertical))
            HotIf (*) => IsWplaceWindow() && _state = State.DrawVertical
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.DrawLastColorLine("V"))
            Hotkey("+" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDrawLine("V"))
        case KeyMode.directly:
            HotIf (*) => IsWplaceWindow()
            Hotkey("*" _SettingsData.DrawVerticalKey.key, (*) => ActionLogic.DrawLastColorLine("V"))
            Hotkey("+" _SettingsData.DrawVerticalKey.key, (*) => ActionLogic.PickAndDrawLine("V"))
    }
if _SettingsData.DrawHorizontalKey.key
    switch _SettingsData.DrawHorizontalKey.mode {
        case KeyMode.heldDown:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.DrawHorizontalKey.key, (*) => SwitchState_KeyHeldDown(State.DrawHorizontal,
                _SettingsData.DrawHorizontalKey.key))
            HotIf (*) => IsWplaceWindow() && _state = State.DrawHorizontal
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.DrawLastColorLine("H"))
            Hotkey("+" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDrawLine("H"))
        case KeyMode.toggle:
            HotIfWinActive TitleWindowUsed
            Hotkey(_SettingsData.DrawHorizontalKey.key, (*) => SwitchState_KeyDown(State.DrawHorizontal))
            HotIf (*) => IsWplaceWindow() && _state = State.DrawHorizontal
            Hotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.DrawLastColorLine("H"))
            Hotkey("+" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDrawLine("H"))
        case KeyMode.directly:
            HotIf (*) => IsWplaceWindow()
            Hotkey("*" _SettingsData.DrawHorizontalKey.key, (*) => ActionLogic.DrawLastColorLine("H"))
            Hotkey("+" _SettingsData.DrawHorizontalKey.key, (*) => ActionLogic.PickAndDrawLine("H"))
    }
HotIf (*) => WinActive(TitleWindowUsed)
Hotkey("*w", (*) => "")
Hotkey("*a", (*) => "")
Hotkey("*s", (*) => "")
Hotkey("*d", (*) => "")
HotIf (*) => IsWplaceWindow()
Hotkey("MButton", (*) => ActionLogic.Drag("MButton"))
HotIf (*) => IsWplaceWindow()
Hotkey("*h", (*) => ActionLogic.DrawLastColorLine("H"))
Hotkey("*v", (*) => ActionLogic.DrawLastColorLine("V"))
if _SettingsData.openWplaceOnStart
    Run(_SettingsData.wplaceWeb)
if _SettingsData.openCustomOnStart && _SettingsData.customUrl != ""
    Run(_SettingsData.customUrl)
if _SettingsData.openThisPageOnStart
    SettingGui.Show()
StatusGui.Init()
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"
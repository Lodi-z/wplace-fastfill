#MaxThreads 255
#MaxThreadsPerHotkey 1
class SettingsData {
    openThisPageOnStart := true
    wplaceWeb := "https://wplace.live/"
    openWplaceOnStart := false
    customUrl := ""
    openCustomOnStart := false
    menuKey := "^Esc"
    fillKey := "z"
    pickAndDrawKey := "x"
    fillOnHoverPickOnClickKey := "c"
    triggerKey := "LButton"
    pickDelay := 100
    playSnd := false
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
            this.TryRead(&_SettingsData.fillKey, "Hotkeys", "FillKey")
            this.TryRead(&_SettingsData.pickAndDrawKey, "Hotkeys", "PickKey")
            this.TryRead(&_SettingsData.fillOnHoverPickOnClickKey, "Hotkeys", "FillOnHoverPickOnClickKey")
            this.TryRead(&_SettingsData.triggerKey, "Hotkeys", "TriggerKey")
            this.TryRead(&_SettingsData.pickDelay, "Delay", "PickDelay")
            this.TryRead(&_SettingsData.playSnd, "Other", "PlaySnd")
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
        IniWrite(_SettingsData.fillKey, WplaceConfig.file, "Hotkeys", "FillKey")
        IniWrite(_SettingsData.pickAndDrawKey, WplaceConfig.file, "Hotkeys", "PickKey")
        IniWrite(_SettingsData.fillOnHoverPickOnClickKey, WplaceConfig.file, "Hotkeys", "FillOnHoverPickOnClickKey")
        IniWrite(_SettingsData.triggerKey, WplaceConfig.file, "Hotkeys", "TriggerKey")
        IniWrite(_SettingsData.pickDelay, WplaceConfig.file, "Delay", "PickDelay")
        IniWrite(_SettingsData.playSnd, WplaceConfig.file, "Other", "PlaySnd")
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
            h1_font := "s" FontTools.ScaleFontSize(14) " bold"
            h2_font := "s" FontTools.ScaleFontSize(12) " bold"
            h3_font := "s" FontTools.ScaleFontSize(11) " bold"
            body_font := "norm s" FontTools.ScaleFontSize(11)
            h2_first_transform := "x30 y60"
            h2_transform := "x30 y+10"
            h3_transform := "x40 y+10"
            body_transform := "x50 y+4"
            this.instance.Title := "Wplace工具 - 菜单                  Ciallo～(∠・ω< )⌒★"
            this.instance.SetFont(h2_font)
            this.instance.AddText("x30", "作者：洛迪 |")
            this.instance.SetFont(body_font)
            this.instance.AddLink("x+10",
                'b站主页：<a href="https://space.bilibili.com/418324770">space.bilibili.com/418324770</a>')
            tab := this.instance.AddTab3("x18 y+10 w480 h480", ["介绍", "设置", "赞助"])
            tab.UseTab("介绍")
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_first_transform, "功能说明：")
            this.instance.SetFont(body_font)
            this.instance.SetFont(h3_font)
            this.instance.AddText(h3_transform, "1. 织色如缕")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform,
                Format("按住 {} 进入此模式", StringTools.HotkeyToString(_SettingsData.fillKey)))
            this.instance.AddText(body_transform,
                Format("• 长按{}：对鼠标移动途中连续填充当前颜色", StringTools.HotkeyToString(_SettingsData.triggerKey)))
            this.instance.SetFont(h3_font)
            this.instance.AddText(h3_transform, "2. 摄色流转")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform,
                Format("按住 {} 进入此模式", StringTools.HotkeyToString(_SettingsData.pickAndDrawKey)))
            this.instance.AddText(body_transform,
                Format("• 点击{}：取色当前颜色后立即填入", StringTools.HotkeyToString(_SettingsData.triggerKey)))
            this.instance.AddText(body_transform, "• 继续长按：滑动到相同颜色时自动填充")
            this.instance.AddText(body_transform, "• 点击到地图背景色时不执行，防止误触")
            this.instance.AddText(body_transform, "• 点击到上次取色颜色时直接填入")
            this.instance.SetFont(h3_font)
            this.instance.AddText(h3_transform, "3. 绘彩巡游")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform,
                Format("按下 {} 进入此模式", StringTools.HotkeyToString(_SettingsData.fillOnHoverPickOnClickKey)))
            this.instance.AddText(body_transform, "• 始终执行：鼠标滑动到相同颜色时自动填充")
            this.instance.AddText(body_transform,
                Format("• 点击{}：取色当前颜色后立即填入", StringTools.HotkeyToString(_SettingsData.triggerKey)))
            this.instance.SetFont(h3_font)
            this.instance.AddText(h3_transform, "便捷操作")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform, "• 鼠标中键拖动画布（地图）")
            this.instance.AddText(body_transform, "• 右键擦除颜色（网站原有功能，只是提醒一下）")
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "注意事项：")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform, "键位可替换，如需替换，请移步设置选项卡")
            this.instance.AddText(body_transform, "如果【取色后立即填入该颜色】功能无法触发，请调高取色延迟！")
            tab.UseTab("设置")
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_first_transform, "启动设置")
            this.instance.SetFont(body_font)
            this.instance.AddCheckbox(body_transform " vOpenThisPage", "启动时自动打开本页面").Value := _SettingsData.openThisPageOnStart
            this.instance.AddCheckbox(body_transform " vOpenWplace", "启动时自动打开Wplace网站").Value := _SettingsData.openWplaceOnStart
            this.instance.AddLink("yp", '<a href="' _SettingsData.wplaceWeb '">' _SettingsData.wplaceWeb '</a>')
            this.instance.AddCheckbox(body_transform " vOpenCustom", "启动时自动打开自定义程序").Value := _SettingsData.openCustomOnStart
            this.instance.AddEdit("vCustomUrl w160 yp", _SettingsData.customUrl)
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "自定义按键（为空时则不使用该功能）：")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform " w120", "打开菜单键：")
            this.instance.AddHotkey("vPauseKey yp w165", _SettingsData.menuKey)
            this.instance.AddText(body_transform " w120", "织色如缕：")
            this.instance.AddHotkey("vFillKey yp w165", _SettingsData.fillKey)
            this.instance.AddText(body_transform " w120", "摄色流转：")
            this.instance.AddHotkey("vPickKey yp w165", _SettingsData.pickAndDrawKey)
            this.instance.AddText(body_transform " w120", "绘彩巡游：")
            this.instance.AddHotkey("vFhpcHk yp w165", _SettingsData.fillOnHoverPickOnClickKey)
            this.instance.AddText(body_transform " w120", "触发：")
            this.instance.AddDropDownList("vTriggerKey yp w165", ["左键", "空格"]).Value := Map("LButton", 1, "Space", 2)[
                _SettingsData.triggerKey]
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "延迟设置")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform " w120", "取色延迟(ms)：")
            this.instance.AddEdit("vPickDelay yp w80 Number", _SettingsData.pickDelay)
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "其他设置")
            this.instance.SetFont(body_font)
            this.instance.AddCheckbox(body_transform " vPlaySnd", "涂色时播放音效（会让程序有一点延迟）").Value := _SettingsData.playSnd
            this.instance.AddButton("x30 y470" " w455", "保存设置并重启该脚本").OnEvent("Click", (*) => this.SaveAndReload())
            tab.UseTab("赞助")
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_first_transform, "要赞助我一杯咖啡吗？～(∠・ω< )⌒★")
            this.instance.SetFont(body_font)
            this.instance.AddPicture("x18 y+0 w476 h357", "image/QR_code.png")
            tab.UseTab()
            this.instance.AddButton("x18 w234", "退出程序").OnEvent("Click", (*) => ExitApp())
            this.instance.AddButton("yp w234", "确定").OnEvent("Click", (*) => this.OnStartClick())
            this.instance.OnEvent("Close", (*) => this.OnStartClick())
            this.instance.Show("w514 ")
            IME.SetEnglish()
        }
    }
    static Close() {
        try this.instance.Destroy()
        this.instance := false
    }
    static SaveAndReload() {
        _SettingsData.openThisPageOnStart := this.instance["OpenThisPage"].Value
        _SettingsData.openWplaceOnStart := this.instance["OpenWplace"].Value
        _SettingsData.customUrl := this.instance["CustomUrl"].Text
        _SettingsData.openCustomOnStart := this.instance["OpenCustom"].Value
        _SettingsData.menuKey := this.instance["PauseKey"].Value
        _SettingsData.fillKey := this.instance["FillKey"].Value
        _SettingsData.pickAndDrawKey := this.instance["PickKey"].Value
        _SettingsData.fillOnHoverPickOnClickKey := this.instance["FhpcHk"].Value
        triggerKeyArray := ["LButton", "Space"]
        _SettingsData.triggerKey := triggerKeyArray[this.instance["TriggerKey"].Value]
        if this.instance["PickDelay"].Value
            _SettingsData.pickDelay := Integer(this.instance["PickDelay"].Value)
        _SettingsData.playSnd := this.instance["PlaySnd"].Value
        WplaceConfig.save()
        Reload()
    }
    static HasUnsavedChanges() {
        triggerKeyArray := ["LButton", "Space"]
        curTriggerKey := triggerKeyArray[this.instance["TriggerKey"].Value]
        if _SettingsData.openThisPageOnStart != this.instance["OpenThisPage"].Value ||
            _SettingsData.openWplaceOnStart != this.instance["OpenWplace"].Value ||
            _SettingsData.customUrl != this.instance["CustomUrl"].Text ||
            _SettingsData.openCustomOnStart != this.instance["OpenCustom"].Value ||
            _SettingsData.menuKey != this.instance["PauseKey"].Value ||
            _SettingsData.fillKey != this.instance["FillKey"].Value ||
            _SettingsData.pickAndDrawKey != this.instance["PickKey"].Value ||
            _SettingsData.fillOnHoverPickOnClickKey != this.instance["FhpcHk"].Value ||
            _SettingsData.triggerKey != curTriggerKey ||
            _SettingsData.playSnd != this.instance["PlaySnd"].Value ||
            _SettingsData.pickDelay != Integer(this.instance["PickDelay"].Value)
            return true
        return false
    }
    static OnStartClick() {
        if this.HasUnsavedChanges() {
            res := MsgBox("设置已更改但未保存，是否保存？", "提示", 0x23)
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
        "Fill_Begin", A_ScriptDir "\sounds\曼波↗.wav",
        "Fill_End", A_ScriptDir "\sounds\曼波↘.wav",
        "Pick", A_ScriptDir "\sounds\哦耶.wav",
        "Draw", A_ScriptDir "\sounds\wow~.wav",
    )
    static PlayAudioAsync(name) {
        if (!_SettingsData.playSnd)
            return
        AudioTools.PlayAudioAsync this.soundMap[name]
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
        pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
        if ColorTools.IsSimilarToAny(pixelColor, [0xb1c3eb, 0xc4d6fe, 0x5f7199, 0xfaf7f5, 0x959290, 0xe7e4e2], 4) ||
        ColorTools.IsSameToAny(pixelColor, [0xf8f4f0, 0x9ebdff])
            return
        if this.lastPickColor != pixelColor {
            BlockInput "MouseMove"
            Send("i")
            SendEvent("{LButton}")
            Sleep(_SettingsData.pickDelay)
            SendEvent("{Space}")
            BlockInput "MouseMoveOff"
            this.lastPickColor := pixelColor
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
        while ShouldContinue() {
            MouseGetPos &mouseX, &mouseY
            pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
            if (canDraw && pixelColor = this.lastPickColor) {
                BlockInput "MouseMove"
                SendEvent("{Space}")
                BlockInput "MouseMoveOff"
                canDraw := false
                AudioSound.PlayAudioAsync("Draw")
            }
            else if (!canDraw && pixelColor != this.lastPickColor) {
                canDraw := true
            }
        }
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
    FillOnHoverPickOnClick: 3
}
_state := State.Normal
SwitchState_KeyHeldDown(newState, key) {
    global _state
    oldState := _state
    _state := newState
    HotkeyTools.WaitForComboRelease(key)
    _state := oldState
}
SwitchState_KeyDown(newState) {
    global _state
    if (_state = newState) {
        _state := State.Normal
        return false
    }
    _state := newState
    return true
}
TryHotkey(keyName, callBack, Options := "") {
    if keyName
        Hotkey(keyName, callBack, Options)
}
TryHotkey(_SettingsData.menuKey, (*) => SettingGui.Show())
HotIfWinActive TitleWindowUsed
TryHotkey(_SettingsData.fillKey, (*) => SwitchState_KeyHeldDown(State.Fill, _SettingsData.fillKey))
TryHotkey(_SettingsData.pickAndDrawKey, (*) => SwitchState_KeyHeldDown(State.PickAndDraw, _SettingsData.pickAndDrawKey))
TryHotkey(_SettingsData.fillOnHoverPickOnClickKey, (*) => SwitchFillOnHoverPickOnClickKey(), "T2")
SwitchFillOnHoverPickOnClickKey() {
    if SwitchState_KeyDown(State.FillOnHoverPickOnClick)
        ActionLogic.DrawLastColor((*) => _state = State.FillOnHoverPickOnClick)
}
HotIf (*) => IsWplaceWindow()
TryHotkey("MButton", (*) => ActionLogic.Drag("MButton"))
HotIf (*) => IsWplaceWindow() && _state = State.Fill
TryHotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.Fill(_SettingsData.triggerKey))
HotIf (*) => IsWplaceWindow() && _state = State.PickAndDraw
TryHotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDraw(_SettingsData.triggerKey, true))
HotIf (*) => IsWplaceWindow() && _state = State.FillOnHoverPickOnClick
TryHotkey("*" _SettingsData.triggerKey, (*) => ActionLogic.PickAndDraw(_SettingsData.triggerKey, false))
if _SettingsData.openWplaceOnStart
    Run(_SettingsData.wplaceWeb)
if _SettingsData.openCustomOnStart && _SettingsData.customUrl != ""
    Run(_SettingsData.customUrl)
if _SettingsData.openThisPageOnStart
    SettingGui.Show()
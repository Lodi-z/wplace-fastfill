#MaxThreads 255
#MaxThreadsPerHotkey 255
class SettingsData {
    openWplaceOnStart := false
    customUrl := ""
    openCustomOnStart := false
    pauseKey := "Esc"
    triggerKey := "LButton"
    fillKey := "z"
    pickKey := "x"
    pickDelay := 100
    wplaceWeb := "https://wplace.live/"
    openThisPageOnStart := true
    playSnd := false
}
class WplaceConfig {
    static file := "wplace_config.ini"
    static load() {
        try {
            _SettingsData.pauseKey := IniRead(WplaceConfig.file, "Hotkeys", "PauseKey")
            _SettingsData.fillKey := IniRead(WplaceConfig.file, "Hotkeys", "FillKey")
            _SettingsData.pickKey := IniRead(WplaceConfig.file, "Hotkeys", "PickKey")
            _SettingsData.openThisPageOnStart := IniRead(WplaceConfig.file, "Startup", "OpenThisPage")
            _SettingsData.openWplaceOnStart := IniRead(WplaceConfig.file, "Startup", "OpenWplace")
            _SettingsData.customUrl := IniRead(WplaceConfig.file, "Startup", "CustomUrl")
            _SettingsData.openCustomOnStart := IniRead(WplaceConfig.file, "Startup", "OpenCustom")
            _SettingsData.playSnd := IniRead(WplaceConfig.file, "Other", "PlaySnd")
            _SettingsData.triggerKey := IniRead(WplaceConfig.file, "Hotkeys", "TriggerKey")
            _SettingsData.pickDelay := IniRead(WplaceConfig.file, "Delay", "PickDelay")
        }
    }
    static save() {
        IniWrite(_SettingsData.pauseKey, WplaceConfig.file, "Hotkeys", "PauseKey")
        IniWrite(_SettingsData.fillKey, WplaceConfig.file, "Hotkeys", "FillKey")
        IniWrite(_SettingsData.pickKey, WplaceConfig.file, "Hotkeys", "PickKey")
        IniWrite(_SettingsData.openThisPageOnStart, WplaceConfig.file, "Startup", "OpenThisPage")
        IniWrite(_SettingsData.openWplaceOnStart, WplaceConfig.file, "Startup", "OpenWplace")
        IniWrite(_SettingsData.customUrl, WplaceConfig.file, "Startup", "CustomUrl")
        IniWrite(_SettingsData.openCustomOnStart, WplaceConfig.file, "Startup", "OpenCustom")
        IniWrite(_SettingsData.playSnd, WplaceConfig.file, "Other", "PlaySnd")
        IniWrite(_SettingsData.triggerKey, WplaceConfig.file, "Hotkeys", "TriggerKey")
        IniWrite(_SettingsData.pickDelay, WplaceConfig.file, "Delay", "PickDelay")
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
            this.instance.Opt("-SysMenu +DPIScale")
            h1_font := "s" FontTools.ScaleFontSize(14) " bold"
            h2_font := "s" FontTools.ScaleFontSize(12) " bold"
            body_font := "norm s" FontTools.ScaleFontSize(11)
            h2_first_transform := "x30 y80"
            h2_transform := "x30 y+20"
            body_transform := "x40 y+10"
            this.instance.Title := "Ciallo～(∠・ω< )⌒★                  Wplace工具 - 菜单"
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
            this.instance.AddText(body_transform, Format("
			(
				可按【{1}】打开该菜单

				1-通过持续按住功能按键时可使【{4}】点击时执行多种功能

				·当持续按住【{2}】时，长按【{4}】连续填充当前颜色

				·当持续按住【{3}】时，点击【{4}】取色后立即填入该颜色，
				
				  如果继续长按【{4}】，并滑动到相同于本次取色的颜色，则自动填充

				  用途-点击Blue Marble生成的小方块，取色填色更方便了

				  并且做了额外的判断，如果点击到地图背景色则不会执行

				  如果点击到上一次取色的颜色，则直接填入，不会再次浪费时间取色

				2-拖动画布（地图）也可直接使用鼠标中键

				3-右键擦除颜色（网站原有功能，只是提醒一下）
)",
                StringTools.HotkeyToString(_SettingsData.pauseKey),
                StringTools.HotkeyToString(_SettingsData.fillKey),
                StringTools.HotkeyToString(_SettingsData.pickKey),
                StringTools.HotkeyToString(_SettingsData.triggerKey)))
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "注意事项：")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform, "
			(
				键位可替换，如需替换，请移步设置选项卡

				如果【取色后立即填入该颜色】功能无法触发，请调高取色延迟！
)")
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
            this.instance.AddText(h2_transform, "自定义按键（为空时保存则忽略本次设置）：")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform " w120", "暂停脚本键：")
            pauseHK := this.instance.AddHotkey("vPauseKey yp w165", _SettingsData.pauseKey)
            this.instance.AddButton("yp w60", "重置").OnEvent("Click", (*) => (pauseHK.Value := _SettingsDataDefault.pauseKey
            ))
            this.instance.AddText(body_transform " w120", "填充键：")
            fillHK := this.instance.AddHotkey("vFillKey yp w165", _SettingsData.fillKey)
            this.instance.AddButton("yp w60", "重置").OnEvent("Click", (*) => (fillHK.Value := _SettingsDataDefault.fillKey
            ))
            this.instance.AddText(body_transform " w120", "取色键：")
            pickHK := this.instance.AddHotkey("vPickKey yp w165", _SettingsData.pickKey)
            this.instance.AddButton("yp w60", "重置").OnEvent("Click", (*) => (pickHK.Value := _SettingsDataDefault.pickKey
            ))
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "延迟设置")
            this.instance.SetFont(body_font)
            this.instance.AddText(body_transform " w120", "取色延迟(ms)：")
            pickDelayEdit := this.instance.AddEdit("vPickDelay yp w80 Number", _SettingsData.pickDelay)
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_transform, "其他设置")
            this.instance.SetFont(body_font)
            this.instance.AddCheckbox(body_transform " vPlaySnd", "涂色时播放曼波音效~").Value := _SettingsData.playSnd
            this.instance.AddButton(h2_transform " w380", "保存设置并重启该脚本").OnEvent("Click", (*) => this.SaveAndReload())
            tab.UseTab("赞助")
            this.instance.SetFont(h2_font)
            this.instance.AddText(h2_first_transform, "要赞助我一杯咖啡吗？～(∠・ω< )⌒★")
            this.instance.SetFont(body_font)
            this.instance.AddPicture("x18 y+0 w476 h357", "image/QR_code.png")
            tab.UseTab()
            this.instance.AddButton("x18 w234", "关闭脚本").OnEvent("Click", (*) => ExitApp())
            this.instance.AddButton("yp w234", "开始使用").OnEvent("Click", (*) => this.OnStartClick())
            this.instance.OnEvent("Close", (*) => ExitApp())
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
        if this.instance["PauseKey"].Value
            _SettingsData.pauseKey := this.instance["PauseKey"].Value
        if this.instance["FillKey"].Value
            _SettingsData.fillKey := this.instance["FillKey"].Value
        if this.instance["PickKey"].Value
            _SettingsData.pickKey := this.instance["PickKey"].Value
        if this.instance["PickDelay"].Value
            _SettingsData.pickDelay := Integer(this.instance["PickDelay"].Value)
        _SettingsData.playSnd := this.instance["PlaySnd"].Value
        WplaceConfig.save()
        Reload()
    }
    static HasUnsavedChanges() {
        if _SettingsData.openThisPageOnStart != this.instance["OpenThisPage"].Value ||
            _SettingsData.openWplaceOnStart != this.instance["OpenWplace"].Value ||
            _SettingsData.customUrl != this.instance["CustomUrl"].Text ||
            _SettingsData.openCustomOnStart != this.instance["OpenCustom"].Value ||
            _SettingsData.pauseKey != this.instance["PauseKey"].Value ||
            _SettingsData.fillKey != this.instance["FillKey"].Value ||
            _SettingsData.pickKey != this.instance["PickKey"].Value ||
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
        "曼波↗", A_ScriptDir "\sounds\曼波↗.wav",
        "曼波↘", A_ScriptDir "\sounds\曼波↘.wav",
        "哦耶", A_ScriptDir "\sounds\哦耶.wav",
        "wow~", A_ScriptDir "\sounds\wow~.wav",
    )
    static PlayAudioAsync(name) {
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
}
class ActionLogic {
    static DoLBtn() {
        if !this.IsWplaceWindow(&winId) {
            this.Normal("LButton")
            return
        }
        if WinExist("A") != winId
            WinActivate("ahk_id " winId)
        this.ByKey()
    }
    static DoMBtn() {
        MouseGetPos(&startX, &startY)
        if !this.IsWplaceWindow(&winId) {
            this.Normal("MButton")
            return
        }
        this.Drag(startX, startY)
    }
    static IsWplaceWindow(&winId) {
        MouseGetPos(, , &winId)
        if (winId) {
            title := WinGetTitle(winId)
            return InStr(title, "Wplace - Paint the world")
        }
        else return false
    }
    static Normal(key) {
        SendEvent("{" key " down}")
        KeyWait(key)
        SendEvent("{" key " up}")
    }
    static ByKey() {
        if HotkeyTools.IsComboPressed(_SettingsData.fillKey, "P")
            this.Fill()
        else if HotkeyTools.IsComboPressed(_SettingsData.pickKey, "P")
            this.Pick()
        else this.Normal("LButton")
    }
    static Fill() {
        SendEvent("{Space down}")
        if (_SettingsData.playSnd)
            AudioSound.PlayAudioAsync("曼波↗")
        KeyWait("LButton")
        SendEvent("{Space up}")
        if (_SettingsData.playSnd)
            AudioSound.PlayAudioAsync("曼波↘")
    }
    static lastPickColor := false
    static Pick() {
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
        if (_SettingsData.playSnd)
            AudioSound.PlayAudioAsync("哦耶")
        canDraw := false
        while GetKeyState("LButton", "P") {
            MouseGetPos &mouseX, &mouseY
            pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
            if (canDraw && pixelColor = this.lastPickColor) {
                BlockInput "MouseMove"
                SendEvent("{Space}")
                if (_SettingsData.playSnd)
                    AudioSound.PlayAudioAsync("wow~")
                BlockInput "MouseMoveOff"
                canDraw := false
            }
            else if (!canDraw && pixelColor != this.lastPickColor) {
                canDraw := true
            }
        }
    }
    static Drag(startX, startY) {
        isDragging := false
        dragThreshold := 3
        while GetKeyState("MButton", "P") {
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
global _SettingsData := SettingsData()
global _SettingsDataDefault := SettingsData()
WplaceConfig.load()
try A_TrayMenu.Delete("&Pause Script")
try A_TrayMenu.Rename("&Suspend Hotkeys", "暂停(&S)")
try A_TrayMenu.Rename("E&xit", "退出(&X)")
A_TrayMenu.Insert("1&", "设置(&T)", (*) => SettingGui.Show())
Hotkey(_SettingsData.pauseKey, (*) => SettingGui.Show(), "I1")
Hotkey("LButton", (*) => ActionLogic.DoLBtn())
Hotkey("MButton", (*) => ActionLogic.DoMBtn())
if _SettingsData.openWplaceOnStart
    Run(_SettingsData.wplaceWeb)
if _SettingsData.openCustomOnStart && _SettingsData.customUrl != ""
    Run(_SettingsData.customUrl)
if _SettingsData.openThisPageOnStart
    SettingGui.Show()
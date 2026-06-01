class SettingsData {
    openWplaceOnStart := false
    customUrl := ""
    openCustomOnStart := false
    pauseKey := "Esc"
    pauseKey_default := "Esc"
    fillKey := "z"
    fillKey_default := "z"
    pickKey := "x"
    pickKey_default := "x"
    wplaceWeb := "https://wplace.live/"
    openThisPageOnStart := true
}
class WplaceConfig {
    static file := "wplace_config.ini"
    static load() {
        if FileExist(WplaceConfig.file) {
            _SettingsData.pauseKey := IniRead(WplaceConfig.file, "Hotkeys", "PauseKey", _SettingsData.pauseKey_default)
            _SettingsData.fillKey := IniRead(WplaceConfig.file, "Hotkeys", "FillKey", _SettingsData.fillKey_default)
            _SettingsData.pickKey := IniRead(WplaceConfig.file, "Hotkeys", "PickKey", _SettingsData.pickKey_default)
            _SettingsData.openThisPageOnStart := IniRead(WplaceConfig.file, "Startup", "OpenThisPage", "1")
            _SettingsData.openWplaceOnStart := IniRead(WplaceConfig.file, "Startup", "OpenWplace", "0")
            _SettingsData.customUrl := IniRead(WplaceConfig.file, "Startup", "CustomUrl", "")
            _SettingsData.openCustomOnStart := IniRead(WplaceConfig.file, "Startup", "OpenCustom", "0")
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
    }
}
class PauseGui {
    static instance := false
    static Show() {
        if !this.instance {
            this.instance := Gui()
            this.instance.Opt("AlwaysOnTop -SysMenu +ToolWindow +DPIScale")
            this.instance.Title := "Ciallo～(∠・ω< )⌒★                  Wplace工具 - 暂停中"
            this.instance.SetFont("s14 bold")
            this.instance.AddText(, "当前脚本已暂停，可设置启动选项和快捷键")
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x30 y+10", "作者：洛迪 |")
            this.instance.SetFont()
            this.instance.AddLink("x+10",
                'b站主页：<a href="https://space.bilibili.com/418324770">space.bilibili.com/418324770</a>')
            tab := this.instance.AddTab3("x22 y+10 w480 h440", ["介绍", "设置"])
            tab.UseTab("介绍")
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x30 y120", "功能说明：")
            this.instance.SetFont()
            this.instance.AddText("x40 y+10 w550", "
        (
1-通过持续按住功能按键时可使【鼠标左键点击时执行多种功能】

 ·当持续按住【填充键】时，长按左键连续填充当前颜色

 ·当持续按住【取色键】时，点击左键取色后立即填入该颜色

   用途-点击Blue Marble生成的小方块，取色填色更方便了

   并且做了额外的判断，如果点击到地图背景色则不会执行

   如果点击到上一次取色的颜色，则直接填入，不会再次浪费时间取色

2-拖动画布（地图）也可直接使用鼠标中键

3-右键擦除颜色（网站原有功能，只是提醒一下）
)"
            )
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x30 y+20", "注意事项：")
            this.instance.SetFont()
            this.instance.AddText("x40 y+10 w550", "键位可替换，如需替换，请移步设置选项卡（上方）")
            tab.UseTab("设置")
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x30 y120", "启动设置")
            this.instance.SetFont()
            this.instance.AddCheckbox("x40 y+20 vOpenThisPage", "启动时自动打开本页面").Value := _SettingsData.openThisPageOnStart
            this.instance.AddCheckbox("x40 y+20 vOpenWplace", "启动时自动打开Wplace网站").Value := _SettingsData.openWplaceOnStart
            this.instance.AddLink("yp", '<a href="' _SettingsData.wplaceWeb '">' _SettingsData.wplaceWeb '</a>')
            this.instance.AddCheckbox("x40 y+20 vOpenCustom", "启动时自动打开自定义程序").Value := _SettingsData.openCustomOnStart
            this.instance.AddEdit("vCustomUrl w160 yp", _SettingsData.customUrl)
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x30 y+30", "自定义按键（为空时保存则忽略本次设置）：")
            this.instance.SetFont()
            this.instance.AddText("x40 y+20 w120", "暂停脚本键：")
            pauseHK := this.instance.AddHotkey("vPauseKey yp w165", _SettingsData.pauseKey)
            this.instance.AddButton("yp w60", "重置").OnEvent("Click", (*) => (pauseHK.Value := _SettingsData.pauseKey_default
            ))
            this.instance.AddText("x40 y+20 w120", "填充键：")
            fillHK := this.instance.AddHotkey("vFillKey yp w165", _SettingsData.fillKey)
            this.instance.AddButton("yp w60", "重置").OnEvent("Click", (*) => (fillHK.Value := _SettingsData.fillKey_default
            ))
            this.instance.AddText("x40 y+20 w120", "取色键：")
            pickHK := this.instance.AddHotkey("vPickKey yp w165", _SettingsData.pickKey)
            this.instance.AddButton("yp w60", "重置").OnEvent("Click", (*) => (pickHK.Value := _SettingsData.pickKey_default
            ))
            this.instance.AddButton("x30 y+20 w380", "保存设置并重启该脚本").OnEvent("Click", (*) => this.SaveAndReload())
            tab.UseTab()
            this.instance.AddButton("x22 w234", "关闭脚本").OnEvent("Click", (*) => ExitApp())
            this.instance.AddButton("yp w234", "开始使用").OnEvent("Click", (*) => this.Close())
            this.instance.OnEvent("Close", (*) => ExitApp())
            this.instance.Show()
            Suspend(true)
        }
    }
    static Close() {
        Suspend(false)
        try this.instance.Destroy()
        this.instance := false
    }
    static SaveAndReload() {
        _SettingsData.openWplaceOnStart := this.instance["OpenWplace"].Value
        _SettingsData.openThisPageOnStart := this.instance["OpenThisPage"].Value
        _SettingsData.customUrl := this.instance["CustomUrl"].Text
        _SettingsData.openCustomOnStart := this.instance["OpenCustom"].Value
        if this.instance["PauseKey"].Value
            _SettingsData.pauseKey := this.instance["PauseKey"].Value
        if this.instance["FillKey"].Value
            _SettingsData.fillKey := this.instance["FillKey"].Value
        if this.instance["PickKey"].Value
            _SettingsData.pickKey := this.instance["PickKey"].Value
        WplaceConfig.save()
        Reload()
    }
}
class AudioSound {
    static soundMap := Map(
        "click-down", A_ScriptDir "\sounds\click-down.wav",
        "click-up", A_ScriptDir "\sounds\click-up.wav",
        "click", A_ScriptDir "\sounds\click.wav"
    )
    static Play(name) => SoundPlay(this.soundMap[name])
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
}
class ActionLogic {
    static DoLBtn() {
        if !this.IsWplaceWindow() {
            this.Normal("LButton")
            return
        }
        MouseGetPos(, , &winId)
        if winId && WinGetID("A") != winId
            WinActivate("ahk_id " winId)
        this.ByKey()
    }
    static DoMBtn() {
        MouseGetPos(&startX, &startY)
        if !this.IsWplaceWindow() {
            this.Normal("MButton")
            return
        }
        this.Drag(startX, startY)
    }
    static IsWplaceWindow() {
        MouseGetPos(, , &winId)
        if (winId)
            title := WinGetTitle(winId)
        return InStr(title, "Wplace - Paint the world")
    }
    static Normal(key) {
        SendEvent("{" key " down}")
        KeyWait(key)
        SendEvent("{" key " up}")
    }
    static ByKey() {
        if GetKeyState(_SettingsData.fillKey, "P")
            this.Fill()
        else if GetKeyState(_SettingsData.pickKey, "P")
            this.Pick()
        else this.Normal("LButton")
    }
    static Fill() {
        SendEvent("{Space down}")
        KeyWait("LButton")
        SendEvent("{Space up}")
    }
    static lastPickColor := ""
    static Pick() {
        MouseGetPos &mouseX, &mouseY
        pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
        if ColorTools.IsSimilarToAny(pixelColor, [0xb1c3eb, 0xc4d6fe, 0x5f7199, 0xfaf7f5, 0x959290, 0xe7e4e2], 2)
            return
        if this.lastPickColor = pixelColor
            SendEvent("{Space}")
        else {
            Send("i")
            SendEvent("{LButton}")
            Sleep(100)
            MouseMove mouseX, mouseY, 0
            SendEvent("{Space}")
            this.lastPickColor := pixelColor
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
WplaceConfig.load()
A_TrayMenu.Delete()
A_TrayMenu.Add("⚙️ 暂停/设置", (*) => PauseGui.Show())
A_TrayMenu.Add("❌ 退出", (*) => ExitApp())
Hotkey(_SettingsData.pauseKey, (*) => PauseGui.Show(), "I1")
Hotkey("LButton", (*) => ActionLogic.DoLBtn())
Hotkey("MButton", (*) => ActionLogic.DoMBtn())
if _SettingsData.openWplaceOnStart
    Run(_SettingsData.wplaceWeb)
if _SettingsData.openCustomOnStart && _SettingsData.customUrl != ""
    Run(_SettingsData.customUrl)
if _SettingsData.openThisPageOnStart
    PauseGui.Show()
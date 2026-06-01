class SettingsData {
    openWplaceOnStart := false
    customUrl := ""
    openCustomOnStart := false
    pauseKey := "Space"
    pauseKey_default := "Space"
    toggleKey := "c"
    toggleKey_default := "c"
    wplaceWeb := "https://wplace.live/"
    openThisPageOnStart := true
}
class WplaceConfig {
    static file := "wplace_config.ini"
    static load() {
        if FileExist(WplaceConfig.file) {
            _SettingsData.pauseKey := IniRead(WplaceConfig.file, "Hotkeys", "PauseKey", "Space")
            _SettingsData.toggleKey := IniRead(WplaceConfig.file, "Hotkeys", "ToggleKey", "C")
            _SettingsData.openThisPageOnStart := IniRead(WplaceConfig.file, "Startup", "OpenThisPage", "1")
            _SettingsData.openWplaceOnStart := IniRead(WplaceConfig.file, "Startup", "OpenWplace", "0")
            _SettingsData.customUrl := IniRead(WplaceConfig.file, "Startup", "CustomUrl", "")
            _SettingsData.openCustomOnStart := IniRead(WplaceConfig.file, "Startup", "OpenCustom", "0")
        }
    }
    static save() {
        IniWrite(_SettingsData.pauseKey, WplaceConfig.file, "Hotkeys", "PauseKey")
        IniWrite(_SettingsData.toggleKey, WplaceConfig.file, "Hotkeys", "ToggleKey")
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
            StatusGui.Close()
            this.instance := Gui()
            this.instance.Opt("AlwaysOnTop -SysMenu +ToolWindow")
            this.instance.Title := "Ciallo～(∠・ω< )⌒★				 Wplace工具 - 暂停中"
            this.instance.SetFont("s14 bold")
            this.instance.AddText(, "当前脚本已暂停，可设置启动选项和快捷键。")
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x10 y+10", "作者：洛迪 |")
            this.instance.SetFont()
            this.instance.AddLink(" x+10",
                'b站主页：<a href="https://space.bilibili.com/418324770">https://space.bilibili.com/418324770</a>')
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x10 y+18", "功能说明：")
            this.instance.SetFont()
            this.instance.AddText("x20", "
			(
				1-通过切换状态可使【鼠标左键在Wplace窗口上点击时执行多种功能】
				                          （其他窗口不受影响！）

				 ·当状态为“快速填充”时，长按左键连续填充当前颜色
				
				 ·当状态为“取色并填入”时，点击左键取色后立即填入该颜色

				   用途-点击Blue Marble生成的小方块，取色填色更方便了

				   并且做了额外的判断，如果点击到小方块之外的地方则不会执行


				2-拖动功能替换为鼠标中键
)"
            )
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x10 y+18", "注意事项：")
            this.instance.SetFont()
            this.instance.AddText("x20", "脚本运行时并且鼠标在Wplace窗口时，脚本会替换掉左键和中间，所以")
            this.instance.SetFont("bold")
            this.instance.AddText("y+8", "在Wplace窗口时如需使用原先的键请先按住Alt键")
            this.instance.SetFont()
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x10 y+18", "启动设置")
            this.instance.SetFont()
            this.instance.AddCheckbox("x20 vOpenThisPage h20", "启动时自动打开本页面").Value := _SettingsData.openThisPageOnStart
            this.instance.AddCheckbox("x20 vOpenWplace h20", "启动时自动打开Wplace网站").Value := _SettingsData.openWplaceOnStart
            this.instance.AddLink("w160 x+10", '<a href="' _SettingsData.wplaceWeb '">' _SettingsData.wplaceWeb '</a>')
            this.instance.AddCheckbox("x20 vOpenCustom h20", "启动时自动打开自定义程序").Value := _SettingsData.openCustomOnStart
            this.instance.AddEdit("vCustomUrl w160 x+10", _SettingsData.customUrl)
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x10 y+18", "自定义按键（为空时保存则忽略本次设置）：")
            this.instance.SetFont()
            this.instance.AddText("x20 w80 y+8", "暂停脚本键：")
            pauseHK := this.instance.AddHotkey("vPauseKey x+10 w120", _SettingsData.pauseKey)
            this.instance.AddButton("x+10 w60", "重置").OnEvent("Click", (*) => (pauseHK.Value := _SettingsData.pauseKey_default
            ))
            this.instance.AddText("x20 w80 y+8", "切换状态键：")
            toggleHK := this.instance.AddHotkey("vToggleKey x+10 w120", _SettingsData.toggleKey)
            this.instance.AddButton("x+10 w60", "重置").OnEvent("Click", (*) => (toggleHK.Value := _SettingsData.toggleKey_default
            ))
            this.instance.AddButton("x10 w190 y+18", "关闭脚本").OnEvent("Click", (*) => ExitApp())
            this.instance.AddButton("x+20 w190", "保存设置并开始使用").OnEvent("Click", (*) => this.SaveAndClose())
            this.instance.OnEvent("Close", (*) => ExitApp())
            this.instance.Show()
            Suspend(true)
        }
    }
    static SaveAndClose() {
        if this.instance {
            if _SettingsData.openWplaceOnStart != this.instance["OpenWplace"].Value
                _SettingsData.openWplaceOnStart := this.instance["OpenWplace"].Value
            if _SettingsData.openThisPageOnStart != this.instance["OpenThisPage"].Value
                _SettingsData.openThisPageOnStart := this.instance["OpenThisPage"].Value
            if _SettingsData.customUrl != this.instance["CustomUrl"].Text
                _SettingsData.customUrl := this.instance["CustomUrl"].Text
            if _SettingsData.openCustomOnStart != this.instance["OpenCustom"].Value
                _SettingsData.openCustomOnStart := this.instance["OpenCustom"].Value
            newPauseKey := this.instance["PauseKey"].Value
            if newPauseKey && newPauseKey != _SettingsData.pauseKey
                SetHotKey_PauseGuiShow(newPauseKey)
            newToggleKey := this.instance["ToggleKey"].Value
            if newToggleKey && newToggleKey != _SettingsData.toggleKey
                SetHotKey_StatusGuiToggleActive(newToggleKey)
            WplaceConfig.save()
            Suspend(false)
            try this.instance.Destroy()
            this.instance := false
            StatusGui.Show()
        }
    }
    static StartupActions() {
        if _SettingsData.openWplaceOnStart {
            Run(_SettingsData.wplaceWeb)
        }
        if _SettingsData.openCustomOnStart && _SettingsData.customUrl != "" {
            Run(_SettingsData.customUrl)
        }
    }
}
class StatusType {
    static Fill := 0
    static Pick := 1
}
class StatusGui {
    static instance := false
    static status := StatusType.Fill
    static statusMap := Map(
        StatusType.Fill, "快速填充",
        StatusType.Pick, "取色并填入"
    )
    static Show() {
        if !this.instance {
            this.instance := Gui()
            this.instance.Opt("AlwaysOnTop -DPIScale -Caption +ToolWindow")
            this.instance.SetFont("s12 bold")
            this.instance.AddText("x5 vStatusText", "状态：文字文字文字")
            this.instance.SetFont()
            this.instance.AddButton("w120", "切换状态").OnEvent("Click", (*) => this.ToggleActive())
            this.instance.AddText(, "Ciallo～(∠・ω< )⌒★")
            this.instance.AddButton("w120", "暂停脚本").OnEvent("Click", (*) => PauseGui.Show())
            this.instance.AddButton("w120", "关闭脚本").OnEvent("Click", (*) => ExitApp())
            this.instance.SetFont("s12 bold")
            this.instance.AddText(, "按键提示：")
            this.instance.SetFont()
            this.instance.AddText("x10", "切换状态：" _SettingsData.toggleKey "键")
            this.instance.AddText(, "暂停脚本：" _SettingsData.pauseKey "键")
            this.instance.AddText("w120 vStatusTextTip", "左键")
            this.instance.AddText(, "拖动区域：中键")
            this.instance.OnEvent("Close", (*) => ExitApp())
            screenW := A_ScreenWidth
            screenH := A_ScreenHeight
            guiW := 130
            guiH := 320
            this.instance.Show("x" screenW - guiW " y" Round(screenH / 2 - guiH) " w" guiW "h" guiH)
        }
        this.instance.Show()
        this.instance["StatusText"].Text := this.statusMap[this.status] "中"
        this.instance["StatusTextTip"].Text := this.statusMap[this.status] "：左键"
    }
    static ToggleActive() {
        this.status := !this.status
        this.Show()
    }
    static Close() {
        if this.instance {
            this.instance.Destroy()
            this.instance := false
        }
    }
}
class AudioSound {
    static soundMap := Map(
        "click-down", A_ScriptDir "\sounds\click-down.wav",
        "click-up", A_ScriptDir "\sounds\click-up.wav",
        "click", A_ScriptDir "\sounds\click.wav"
    )
    static Play(name) {
        file := AudioSound.soundMap[name]
        ToolTip "尝试播放文件: " file
        if FileExist(file) {
            if !SoundPlay(file, "Wait") {
                ToolTip "音效播放失败: " name
            }
        } else {
            ToolTip "音效文件不存在: " name
        }
    }
}
global _SettingsData := SettingsData()
WplaceConfig.load()
SetHotKey_PauseGuiShow(newKey) {
    Hotkey(_SettingsData.pauseKey, "Off")
    Hotkey(newKey, (*) => PauseGui.Show(), "I1 On")
    _SettingsData.pauseKey := newKey
}
SetHotKey_StatusGuiToggleActive(newKey) {
    Hotkey(_SettingsData.toggleKey, "Off")
    Hotkey(newKey, (*) => StatusGui.ToggleActive(), "I2 On")
    _SettingsData.toggleKey := newKey
}
NormalLButtonLogic(key, winId) {
    title := ""
    if (winId)
        title := WinGetTitle(winId)
    if GetKeyState("Alt", "P") || !InStr(title, "Wplace - Paint the world") {
        SendEvent("{" key " down}")
        KeyWait(key)
        SendEvent("{" key " up}")
        return true
    }
    return false
}
$LButton:: {
    MouseGetPos(, , &winId)
    if NormalLButtonLogic("LButton", winId)
        return
    WinActivate("ahk_id " winId)
    switch StatusGui.status {
        case StatusType.Fill:
            SendEvent("{Space down}")
            KeyWait("LButton")
            SendEvent("{Space up}")
        case StatusType.Pick:
            MouseGetPos &mouseX, &mouseY
            pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
            if pixelColor = 0xb1c3eb || pixelColor = 0xc4d6fe || pixelColor = 0x5f7199 ||
                pixelColor = 0xfaf7f5 || pixelColor = 0x959290 || pixelColor = 0xe7e4e2
                return
            Send("i")
            SendEvent("{LButton}")
            Sleep(100)
            SendEvent("{Space}")
        default: return
    }
}
$MButton::
{
    MouseGetPos(&startX, &startY, &winId)
    if NormalLButtonLogic("MButton", winId)
        return
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
Hotkey(_SettingsData.pauseKey, (*) => PauseGui.Show(), "I1")
Hotkey(_SettingsData.toggleKey, (*) => StatusGui.ToggleActive(), "I2")
A_TrayMenu.Delete()
A_TrayMenu.Add("⚙️ 暂停/设置", (*) => PauseGui.Show())
A_TrayMenu.Add("❌ 退出", (*) => ExitApp())
if _SettingsData.openThisPageOnStart
    PauseGui.Show()
else
    StatusGui.Show()
PauseGui.StartupActions()
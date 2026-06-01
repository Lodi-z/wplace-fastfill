#Include <ColorTools>
toggle := false

; 创建GUI窗口
ShowStatusGui() {
	static _gui
	if !IsSet(_gui) {
		_gui := Gui()
		_gui.Opt("AlwaysOnTop -DPIScale -Caption +ToolWindow")
		_gui.Title := "wplace快速填入"
		_gui.AddText("vStatusText", "状态：" (toggle ? "激活" : "未激活"))
		_gui.AddCheckbox("vToggleCheck", "激活映射").OnEvent("Click", (*) => ToggleMapping())
		w := "w" 95
		_gui.AddButton(w, "切换激活").OnEvent("Click", (*) => ToggleMapping())
		_gui.AddButton(w, "打开Wplace").OnEvent("Click", (*) => Run("https://wplace.live/"))
		_gui.AddButton(w, "关闭脚本").OnEvent("Click", (*) => ExitApp())
		_gui.AddText(, "快捷键提示：")
		_gui.AddText("x20", "中键切换激活")
		_gui.AddText(, "左键填入颜色")
		; 屏幕右侧定位
		scrW := A_ScreenWidth
		scrH := A_ScreenHeight
		w := 120
		h := 250
		_gui.Show("x" scrW - w " y" Round(scrH / 2 - h) " w" w " h" h)
	}
	_gui["StatusText"].Text := "状态：" (toggle ? "激活" : "未激活")
	_gui["ToggleCheck"].Value := toggle
}

ToggleMapping() {
	global toggle
	toggle := !toggle
	ShowStatusGui
}

ShowStatusGui()

MButton:: ToggleMapping
#HotIf toggle && IsWplaceWindow()
LButton:: Pick


; RButton:: {
; 	if toggle {
; 		MouseGetPos &mx, &my
; 		color := PixelGetColor(mx, my, "RGB")
; 		if (color = 0xb1c3eb || color = 0xc4d6fe || color = 0x5f7199) {
; 			return
; 		}
; 		Send("i")
; 		SendEvent("{LButton}")
; 		Sleep(300)
; 		SendEvent("{Space}")
; 		return
; 	}
; 	; 未激活时直接发送原右键
; 	SendEvent("{RButton}")
; }
IsWplaceWindow() {
	MouseGetPos(, , &winId)
	if (winId) {
		title := WinGetTitle(winId)
		return InStr(title, "Wplace - Paint the world")
	}
	else return false
}


lastPickColor := false
Pick() {
	MouseGetPos(, , &winId)
	if WinExist("A") != winId
		WinActivate("ahk_id " winId)
	global lastPickColor
	; 长按拾色：在按住左键（LButton）或持续调用 Pick 时，检测鼠标当前像素颜色
	; 如果鼠标移动到与 lastPickColor 相同的颜色，发送一次 Space，然后用 BlockInput 锁住 MouseMove
	; 触发一次后，只有当鼠标移动到非 lastPickColor 的颜色时才允许再次触发

	MouseGetPos &mouseX, &mouseY
	pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
	; 忽略一些不合法或噪声颜色
	if ColorTools.IsSimilarToAny(pixelColor, [0xb1c3eb, 0xc4d6fe, 0x5f7199, 0xfaf7f5, 0x959290, 0xe7e4e2], 4) ||
		ColorTools.IsSameToAny(pixelColor, [0xf8f4f0, 0x9ebdff])
		return

	; 首次拾色（与现有逻辑一致）
	if lastPickColor != pixelColor {
		; 进入 pick 模式：按 i 并点击一次左键以拾取颜色
		BlockInput "MouseMove"
		Send("i")
		SendEvent("{LButton}")
		Sleep(300)
		SendEvent("{Space}")
		BlockInput "MouseMoveOff"
		lastPickColor := pixelColor
	}
	else {
		BlockInput "MouseMove"
		SendEvent("{Space}")
		BlockInput "MouseMoveOff"
	}


	canDraw := false
	while GetKeyState("LButton", "P") {

		MouseGetPos &mouseX, &mouseY
		pixelColor := PixelGetColor(mouseX, mouseY, "RGB")
		if (canDraw && pixelColor = lastPickColor) {
			BlockInput "MouseMove"
			SendEvent("{Space}")
			;Sleep(100)
			BlockInput "MouseMoveOff"
			canDraw := false
		}
		else if (!canDraw && pixelColor != lastPickColor) {
			canDraw := true
		}
	}
}
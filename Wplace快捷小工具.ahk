#MaxThreads 255          ; 增加最大线程数
#MaxThreadsPerHotkey 1 ; 每个热键的最大并发线程数

#Include SettingsData.ahk
#Include WplaceConfig.ahk
#Include SettingGui.ahk
#Include StatusGui.ahk
#Include AudioSound.ahk
#Include ActionLogic.ahk
#Include <HotkeyTools>

; -------------------------加载数据-----------------------------
/**@type {SettingsData}*/
global _SettingsData := SettingsData()
WplaceConfig.Init()

; -------------------------注册托盘图标右键菜单-----------------------------
; 删除Pause Script菜单项
try A_TrayMenu.Delete("&Pause Script")
; 可打开自定义的设置菜单
A_TrayMenu.Insert("1&", "设置(&S)", (*) => SettingGui.Show())
; 重命名其他菜单项
try A_TrayMenu.Rename("&Suspend Hotkeys", "暂停(&P)")
try A_TrayMenu.Rename("E&xit", "退出(&X)")

; -------------------------热键触发条件方法-----------------------------
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

; --------------------------注册热键方法-----------------------------
; ============================== 统一热键注册器 ==============================

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

            ; 按下时直接执行
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

; ============================== 特殊模式单独处理 ============================

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
                    }),-1
            })
            HotIf (*) => IsWplaceWindow() && _state = State.FillOnHoverPickOnClick
            Hotkey("*" trigger, (*) => ActionLogic.PickAndDraw(trigger, false))
    }
}

; ============================== 统一调用 ===================================
; 菜单热键
if _SettingsData.menuKey
    Hotkey(_SettingsData.menuKey, (*) => SettingGui.Show())

; 普通填充
RegisterModeHotkeys(_SettingsData.fillKey, State.Fill,
    (k := _SettingsData.triggerKey) => ActionLogic.Fill(k))

; 取色后绘制
RegisterModeHotkeys(_SettingsData.pickAndDrawKey, State.PickAndDraw,
    (k := _SettingsData.triggerKey) => ActionLogic.PickAndDraw(k, true))
; 垂直线
RegisterModeHotkeys(_SettingsData.DrawVerticalKey, State.DrawVertical,
    (*) => ActionLogic.DrawLastColorLine("V"),
    (*) => ActionLogic.PickAndDrawLine("V"))

; 水平线
RegisterModeHotkeys(_SettingsData.DrawHorizontalKey, State.DrawHorizontal,
    (*) => ActionLogic.DrawLastColorLine("H"),
    (*) => ActionLogic.PickAndDrawLine("H"))

; 特殊模式：悬停填充 + 点击取色
RegisterFillOnHoverPickOnClick()

; ============================== 其余固定热键 ===============================
HotIf (*) => WinActive(TitleWindowUsed)
Hotkey("*w", (*) => "")
Hotkey("*a", (*) => "")
Hotkey("*s", (*) => "")
Hotkey("*d", (*) => "")

HotIf (*) => IsWplaceWindow()
Hotkey("MButton", (*) => ActionLogic.Drag("MButton"))

; -------------------------初次启动时执行-----------------------------
if _SettingsData.openWplaceOnStart
    Run(_SettingsData.wplaceWeb)
if _SettingsData.openCustomOnStart && _SettingsData.customUrl != ""
    Run(_SettingsData.customUrl)

if _SettingsData.openThisPageOnStart
    SettingGui.Show()

StatusGui.Init()

CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"
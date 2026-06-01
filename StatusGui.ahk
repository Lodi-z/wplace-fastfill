class StatusGui {
    /**@type {Gui}*/
    static instance := false
    static picControl := false
    static lastState := 0  ; 缓存上次状态
    static lastWinPos := { x: 0, y: 0 }  ; 缓存上次窗口位置
    static margin := 0 ; 缓存计算的边距
    static actualSize := 0  ; 缓存缩放后的图片尺寸
    static dpiScale := 0  ; 缓存屏幕缩放比

    static visible := false

    static Init() {
        this.instance := Gui("+AlwaysOnTop -Caption +ToolWindow +LastFound")
        margin := _SettingsData.StatusTip.strokeWidth
        size := _SettingsData.StatusTip.size
        this.picControl := this.instance.AddPicture("x" margin " y" margin " w" size " h" size, "image/status/空.jpg")

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
        "image/status/织色如缕.jpg",
        "image/status/摄色流转.jpg",
        "image/status/绘彩巡游.jpg",
        "image/status/纵穿千影.jpg",
        "image/status/横扫苍茫.jpg"
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
        ; 检查状态是否需要更新
        if (state != this.lastState) {
            this.lastState := state
            ; 如果没用有开启始终显示且状态为0则隐藏
            if (state = 0 && !_SettingsData.StatusTip.alwaysDisplay) {
                this.Hide()
                return
            }
            ; 更新图片
            this.picControl.Value := (state = 0) ? "image/status/空.jpg" : this.ImageFiles[state]
        }
        this.Show
    }

    static UpdatePosition(winId) {
        WinGetPos(&winX, &winY, &winWidth, &winHeight, winId)

        ; 检查窗口位置是否发生变化
        if winX = this.lastWinPos.x && winY = this.lastWinPos.y
            return

        this.lastWinPos := { x: winX, y: winY }

        ; 使用预计算的尺寸
        static settings := _SettingsData.StatusTip
        margin := this.margin
        actualSize := this.actualSize
        dpiScale := this.dpiScale
        ; 计算位置
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
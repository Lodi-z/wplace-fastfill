class MouseController {
    static isRunning := false

    static Start() {
        if !this.isRunning {
            this.isRunning := true
            SetTimer(this.BindFunc, 16)
        }
    }

    static Stop() {
        this.isRunning := false
        SetTimer(this.BindFunc, 0)
    }

    static BindFunc := (*) => this.MoveMouse()

    static MoveMouse() {
        static mx := 0, my := 0
        MouseGetPos(&mx, &my)

        ; === WASD 控制移动 ===
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

        ; 如果没有按键，停止移动
        if !(dx || dy) {
            this.Stop()
            return
        }

        ; 修饰键加速/减速
        if GetKeyState("Shift", "P")
            dx *= 2, dy *= 2
        else if GetKeyState("Control", "P")
            dx /= 2, dy /= 2

        ; 移动鼠标
        MouseMove(mx + dx, my + dy, 0)
    }
}

#Include <ColorTools>
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
        ; 忽略地图背景色
        if ColorTools.IsSimilarToAny(pixelColor, ["0xb1c3eb", "0xc4d6fe", "0x5f7199", "0xfaf7f5", "0x959290", "0xe7e4e2"], 4) ||
            ColorTools.IsSameToAny(pixelColor, ["0xf8f4f0", "0x9ebdff"])
            return

        ; 首次拾色（与现有逻辑一致）
        if this.lastPickColor != pixelColor {
            ; 进入 pick 模式：按 i 并点击一次左键以拾取颜色
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
        Sleep(1) ;防止松开后立刻再次触发
    }
    /**@param ShouldContinue function():boolean 返回布尔值的回调函数，true继续循环，false退出循环*/
    static DrawLastColor(ShouldContinue) {
        canDraw := false
        static lastX := -1, lastY := -1

        while ShouldContinue() {
            MouseGetPos &mx, &my
            
            ; === 鼠标未移动：跳过所有操作 ===
            if (mx = lastX && my = lastY) {
                continue
            }

            ; === 超高频取色 ===
            pixelColor := PixelGetColor(mx, my)

            ; === 状态机逻辑 ===
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

            ; === 更新缓存 ===
            lastX := mx
            lastY := my
        }
    }
    ; 通用线段取色填充
    static PickAndDrawLine(direction) {
        this.MouseWinActivate
        BlockInput "MouseMove"
        MouseGetPos &mx, &my
        MouseMove 0, 0, 0
        Sleep 50
        pixelColor := PixelGetColor(mx, my)
        ; 忽略背景颜色
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
    ; 通用线段填充逻辑
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
        ; 边界检查
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
                ; 跳过包含点击点的目标色段
                initialPosVal := isH ? mx : my
                if (!(start <= initialPosVal && initialPosVal <= end && initialColor = target)) {
                    points.Push(isH ? [start, my] : [mx, start])
                }
                inSeg := false
            }
        }
        ; 处理最后一个段（如果到末尾仍 inSeg）
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
        
        static lastPos := false  ; 记录第一次点击的位置
        static resetLastPosAction := () {
            if (GetKeyState("LButton")) {
                ; 重置firstPos并退出定时器
                lastPos := false
                SetTimer(resetLastPosAction, 0)  ; 停止当前定时器
            }
        }
        ; 计算两次点击间隔并在第二次点击后移动到下一个位置
        if (lastPos) {
            ; 计算从第一次点击到当前点击的向量
            deltaX := mx - lastPos[1]
            deltaY := my - lastPos[2]
            
            ; 计算下次点击应该去的位置（当前位置 + 向量）
            ; 根据isH决定只在哪个轴上移动
            if (isH) {
                ; 水平方向，只移动Y轴
                nextX := mx
                nextY := my + deltaY
            } else {
                ; 垂直方向，只移动X轴
                nextX := mx + deltaX
                nextY := my
            }
            
            ; 移动到计算出的位置
            MouseMove nextX, nextY, 0
        }
        else
            MouseMove mx, my, 0
    
        ; 每次点击都记录firstPos
        lastPos := [mx, my]
        ; 停止之前的定时器
        SetTimer(resetLastPosAction, 0)
        ; 启动新的检测定时器
        SetTimer(resetLastPosAction, 100)
    
        
        BlockInput "MouseMoveOff"
    }
    ; 拖动画布
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
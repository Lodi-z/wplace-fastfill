#Include <StringTools>
#Include <IMETools>
class SettingGui {
    /**@type {Gui}*/
    static instance := false
    static settingsMap := false
    static descriptionUpdaters := []  ; 存储所有描述更新函数
    static closeIcon := "image/button/Close.png"
    static minimizeIcon := "image/button/Minimize.png"
    static Show() {
        if !this.instance {
            this.instance := Gui("-Resize -Caption")  
            this.instance.Title := "Wplace工具 - 设置面板                  Ciallo～(∠・ω< )⌒★"

            ; 背景图片
            this.instance.AddPicture("x0 y0 w1000 h780 BackgroundTrans", "image\background.jpg")

            ; 字体设置
            fonts := {
                h1: "s13 bold",
                h2: "s12 bold",
                h3: "s11 bold",
                body: "norm s10"
            }

            ; 获取设置映射
            settingsMap := this.GetSettingsMap()
            
            ; 清空描述更新函数列表
            this.descriptionUpdaters := []

            ; 添加所有内容（单页面设计）
            this.AddAllContent(fonts, settingsMap)

            ; 底部按钮
            this.AddBottomButtons(settingsMap)

            ; 底部状态栏
            this.instance.AddText("x0 y755 w1000 h1 Backgrounda0a0a0")
            this.instance.AddText("x0 y756 w1000 h1 Backgroundffffff")
            this.instance.AddText("x0 y755 w1000 h25 BackgroundTrans Center 0x200", "提示：开启独显直连，高刷屏能提高响应效率哦。如果取色功能无法触发，请调高取色延迟！")

            ; 注册事件
            this.instance.AddPic("x874 y4 w46 h46 BackgroundTrans", this.minimizeIcon).OnEvent("Click", (*) => this.instance.Minimize())
            this.instance.AddPic("x934 y4 w46 h46 BackgroundTrans", this.closeIcon).OnEvent("Click", (*) => this.OnStartClick(settingsMap))
            this.instance.AddText("x0 y0 w874 h53 BackgroundTrans").OnEvent("Click", (*) => PostMessage(0xA1, 2))

            this.instance.Show("w1000 h780")
            IME.SetEnglish()
        }
    }

    ; 添加所有内容
    static AddAllContent(fonts, settingsMap) {
        leftX := 20
        rightX := 520
        currentY := 20
        
        ; ================== 左上角：关于分区 ==================
        this.AddAboutSection(leftX, currentY, fonts)
        currentY += 95
        
        ; ================== 左侧：功能介绍和键位设置 ==================
        this.AddFunctionSection(leftX, &currentY, fonts, settingsMap)
        
        ; ================== 右侧：各种设置 ==================
        currentY := 20
        
        ; 启动设置
        this.AddStartupSettings(rightX, currentY, fonts, settingsMap)
        currentY += 165
        
        ; 基础键位
        this.AddBasicKeys(rightX, currentY, fonts, settingsMap)
        currentY += 115
        
        ; 延迟和速度设置
        this.AddDelaySettings(rightX, currentY, fonts, settingsMap)
        currentY += 125
        
        ; 音效设置
        this.AddSoundSettings(rightX, currentY, fonts, settingsMap)
        currentY += 95
        
        ; 状态提示框设置
        this.AddStatusTipSettings(rightX, currentY, fonts, settingsMap)

        ; 装饰表情包图片
        this.AddDecoration(429, 43, 60, 60)
    }
    
    static AddFunctionSection(x, &y, fonts, settingsMap) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w470 BackgroundTrans", "功能介绍与键位设置")
        y += 30
        
        ; GroupBox - 功能列表
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w470 h445 BackgroundTrans")
        
        y += 20
        this.AddFunctionWithKey(x + 15, y, fonts, "织色如缕→快速填充", "0071d4", State.Fill, _SettingsData.fillKey, "FillKey", "FillKeyMode", settingsMap)
        y += 85
        
        this.AddFunctionWithKey(x + 15, y, fonts, "摄色流转→点击取色填入,长按移动到同颜色自动填充", "0c8d00", State.PickAndDraw, _SettingsData.pickAndDrawKey, "PickKey", "PickKeyMode", settingsMap)
        y += 85
        
        this.AddFunctionWithKey(x + 15, y, fonts, "绘彩巡游→移动到相同颜色自动填充,点击取色后填入", "bc0000", State.FillOnHoverPickOnClick, _SettingsData.fillOnHoverPickOnClickKey, "FhpcHk", "FhpcHkMode", settingsMap)
        y += 85
        
        this.AddFunctionWithKey(x + 15, y, fonts, "纵穿千影→自动绘制一整列某一颜色的像素", "6f00d7", State.DrawVertical, _SettingsData.DrawVerticalKey, "DrawVerticalKey", "DrawVerticalKeyMode", settingsMap)
        y += 85
        
        this.AddFunctionWithKey(x + 15, y, fonts, "横扫苍茫→自动绘制一整行某一颜色的像素", "c8a700", State.DrawHorizontal, _SettingsData.DrawHorizontalKey, "DrawHorizontalKey", "DrawHorizontalKeyMode", settingsMap)
        y += 85
        
        ; 其他功能说明（带GroupBox）
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w470 h65 BackgroundTrans", "其他功能")
        y += 20
        this.instance.AddText("x" (x + 15) " y" y " w440 BackgroundTrans", "• 鼠标中键拖动：移动画布（地图）")
        y += 20
        this.instance.AddText("x" (x + 15) " y" y " w440 BackgroundTrans", "• 长按WASD：控制鼠标移动，Shift加速，Ctrl减速")
    }
    
    ; 添加功能介绍和键位设置（合并显示）
    static AddFunctionWithKey(x, y, fonts, name, color, stateType, keyData, hotkeyVar, modeVar, settingsMap) {
        ; 在左侧添加固定大小的图片（60x60）
        this.instance.AddPicture("x" x " y" y " w60 h60 BackgroundTrans", StatusGui.ImageFiles[stateType])
        
        ; 功能名称和其他内容在图片右侧
        textStartX := x + 70
        this.instance.SetFont(fonts.h3)
        this.instance.AddText("x" textStartX " y" y " BackgroundTrans", name).SetFont("c" color)
        
        ; 键位设置
        y += 24
        this.instance.SetFont(fonts.body)
        this.instance.AddText("x" textStartX " y" y " w50 BackgroundTrans", "键位：")
        hotkeyCtrl := this.instance.AddHotkey("x+5 yp w80 v" hotkeyVar, keyData.key)
        
        ; 触发模式（绘彩巡游只有两个选项）
        KeyModeOptions := stateType = State.FillOnHoverPickOnClick ? 
            ["按住时，点击触发键使用", "按下切换模式后，点触发键使用"]:
            ["按住时，点击触发键使用", "按下切换模式后，点触发键使用", "按下该键直接使用"]
        modeCtrl := this.instance.AddDropDownList("x+8 yp w220 v" modeVar " R" KeyModeOptions.Length, KeyModeOptions)
        modeCtrl.Value := keyData.mode
        
        ; 功能说明区域开始位置
        descY := y + 26
        
        ; 初始显示描述
        descriptions := this.GetFunctionDescription(stateType, keyData)
        descControls := []
        loop descriptions.Length {
            ctrl := this.instance.AddText("x" textStartX " y" descY " w375 v" name "_Desc" A_Index " BackgroundTrans", descriptions[A_Index])
            descControls.Push(ctrl)
            descY += 18
        }
        
        ; 绑定事件：当键位或模式改变时，更新描述
        UpdateDescription := (*) {
            ; 获取当前键位和模式
            currentKey := hotkeyCtrl.Value
            currentMode := modeCtrl.Value
            
            ; 构造临时的 keyData 对象
            tempKeyData := {key: currentKey, mode: currentMode}
            
            ; 获取新的描述
            newDescriptions := this.GetFunctionDescription(stateType, tempKeyData)
            
            ; 更新每个描述控件的文本
            loop Min(descControls.Length, newDescriptions.Length) {
                this.instance[name "_Desc" A_Index].Value := newDescriptions[A_Index]
            }
        }
        
        ; 注册更新函数到静态列表，以便触发键改变时调用
        this.descriptionUpdaters.Push(UpdateDescription)
        
        ; 为热键和下拉框添加事件监听
        hotkeyCtrl.OnEvent("Change", UpdateDescription)
        modeCtrl.OnEvent("Change", UpdateDescription)
    }
    
    ; 获取功能描述
    static GetFunctionDescription(stateType, keyData) {
        GetKeyName(kData) {
            return kData.mode = KeyMode.directly ? StringTools.HotkeyToString(kData.key) : StringTools.HotkeyToString(_SettingsData.triggerKey)
        }
        
        switch stateType {
            case State.Fill:
                return [
                    "• 长按" GetKeyName(keyData) "：连续填充当前颜色"
                ]
            case State.PickAndDraw:
                return [
                    "• 点击" GetKeyName(keyData) "：取色并立即填入",
                    "• 继续长按：滑动到相同颜色时自动填充"
                ]
            case State.FillOnHoverPickOnClick:
                return [
                    "• 始终执行：鼠标滑动到相同颜色时自动填充",
                    "• 点击" StringTools.HotkeyToString(_SettingsData.triggerKey) "：取色并立即填入"
                ]
            case State.DrawVertical:
                return [
                    "• 按住Shift点击" GetKeyName(keyData) "：取色并填充整列",
                    "• 点击" GetKeyName(keyData) "：填充整列上次取色的颜色"
                ]
            case State.DrawHorizontal:
                return [
                    "• 按住Shift点击" GetKeyName(keyData) "：取色并填充整行",
                    "• 点击" GetKeyName(keyData) "：填充整行上次取色的颜色"
                ]
        }
    }
    
    ; 启动设置
    static AddStartupSettings(x, y, fonts, settingsMap) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w460 BackgroundTrans", "启动设置")
        y += 30
        
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w460 h125 BackgroundTrans", "")
        y += 20
        
        this.instance.AddCheckbox("x" (x + 15) " y" y " BackgroundFFF5FF vOpenThisPage", "启动时自动打开设置页面").Value := _SettingsData.openThisPageOnStart
        y += 28
        
        this.instance.AddCheckbox("x" (x + 15) " y" y " BackgroundFFF5FF vOpenWplace", "启动时自动打开Wplace网站")
        this.instance["OpenWplace"].Value := _SettingsData.openWplaceOnStart
        this.instance.AddText("x+5 yp w200 BackgroundTrans", _SettingsData.wplaceWeb)
        y += 28
        
        this.instance.AddCheckbox("x" (x + 15) " y" y " BackgroundFFF5FF vOpenCustom", "启动时自动打开自定义程序")
        this.instance["OpenCustom"].Value := _SettingsData.openCustomOnStart
        this.instance.AddEdit("x+5 yp w215 vCustomUrl", _SettingsData.customUrl)
        y += 28
        
        this.instance.AddText("x" (x + 15) " y" y " w430 BackgroundTrans", "（支持网址、文件路径或应用程序名称）")
    }
    
    ; 基础键位设置
    static AddBasicKeys(x, y, fonts, settingsMap) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w460 BackgroundTrans", "基础键位")
        y += 30
        
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w460 h75 BackgroundTrans", "")
        y += 20
        
        this.instance.AddText("x" (x + 15) " y" y " w80 BackgroundTrans", "打开菜单：")
        this.instance.AddHotkey("x+5 yp w100 vPauseKey", _SettingsData.menuKey)
        y += 30
        
        this.instance.AddText("x" (x + 15) " y" y " w80 BackgroundTrans", "触发键：")
        triggerKeyCtrl := this.instance.AddDropDownList("x+5 yp w150 R2 vTriggerKey", ["左键", "空格"])
        triggerKeyCtrl.Value := Map("LButton", 1, "Space", 2)[_SettingsData.triggerKey]
        
        ; 当触发键改变时，调用所有注册的更新函数
        triggerKeyCtrl.OnEvent("Change", (*) {
            ; 更新全局的 triggerKey 设置（用于 GetFunctionDescription）
            _SettingsData.triggerKey := ["LButton", "Space"][triggerKeyCtrl.Value]
            
            ; 调用所有功能项的描述更新函数
            for updater in this.descriptionUpdaters {
                updater.Call()
            }
        })
    }
    
    ; 延迟和速度设置
    static AddDelaySettings(x, y, fonts, settingsMap) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w460 BackgroundTrans", "延迟与速度")
        y += 30
        
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w460 h85 BackgroundTrans", "")
        y += 20
        
        this.instance.AddText("x" (x + 15) " y" y " w100 BackgroundTrans", "鼠标移动速度：")
        this.instance.AddEdit("x+5 yp w80 vMoveStep Number", _SettingsData.moveStep)
        this.instance.AddText("x+5 yp BackgroundTrans", "像素/16ms")
        y += 30
        
        this.instance.AddText("x" (x + 15) " y" y " w100 BackgroundTrans", "取色后延迟：")
        this.instance.AddEdit("x+5 yp w80 vPickDelay Number", _SettingsData.pickDelay)
        this.instance.AddText("x+5 yp BackgroundTrans", "ms")
        
        this.instance.AddText("x+20 yp w100 BackgroundTrans", "每次填充延迟：")
        this.instance.AddEdit("x+5 yp w80 vDrawDelay Number", _SettingsData.drawDelay)
        this.instance.AddText("x+5 yp BackgroundTrans", "ms")
    }
    
    ; 音效设置
    static AddSoundSettings(x, y, fonts, settingsMap) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w460 BackgroundTrans", "音效设置")
        y += 30
        
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w460 h55 BackgroundTrans", "")
        y += 18
        
        this.instance.AddCheckbox("x" (x + 15) " y" y " w120 BackgroundFFF5FF vPlaySnd", "涂色播放音效").Value := _SettingsData.playSnd
        this.instance.AddDropDownList("x+10 yp w120 R2 vPlaySndType", ["曼波~", "Ciallo~"]).Value := _SettingsData.playSndType
    }
    
    ; 状态提示框设置
    static AddStatusTipSettings(x, y, fonts, settingsMap) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w460 BackgroundTrans", "状态提示框")
        y += 30
        
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w460 h105 BackgroundTrans", "")
        y += 20
        
        this.instance.AddText("x" (x + 15) " y" y " w50 BackgroundTrans", "位置：")
        this.instance.AddDropDownList("x+5 yp w70 R3 vStatusTip_Horizontal", ["左侧", "中间", "右侧"]).Value := _SettingsData.StatusTip.Horizontal
        this.instance.AddDropDownList("x+5 yp w70 R3 vStatusTip_Vertical", ["顶部", "中间", "底部"]).Value := _SettingsData.StatusTip.Vertical
        this.instance.AddText("x+10 yp BackgroundTrans", "边距：")
        this.instance.AddEdit("x+5 yp w50 vStatusTip_margin Number", _SettingsData.StatusTip.margin)
        this.instance.AddText("x+5 yp BackgroundTrans", "px")
        y += 30
        
        this.instance.AddText("x" (x + 15) " y" y " w50 BackgroundTrans", "大小：")
        this.instance.AddEdit("x+5 yp w50 vStatusTip_size Number", _SettingsData.StatusTip.size)
        this.instance.AddText("x+5 yp BackgroundTrans", "px")
        this.instance.AddText("x+20 yp BackgroundTrans", "描边宽度：")
        this.instance.AddEdit("x+5 yp w50 vStatusTip_stroke_width Number", _SettingsData.StatusTip.strokeWidth)
        this.instance.AddText("x+5 yp BackgroundTrans", "px")
        y += 30
        
        this.instance.AddCheckbox("x" (x + 15) " y" y " BackgroundFFF5FF vStatusTip_always_display", "始终显示状态提示框").Value := _SettingsData.StatusTip.alwaysDisplay
    }
    
    ; 关于分区
    static AddAboutSection(x, y, fonts) {
        this.instance.SetFont(fonts.h1)
        this.instance.AddText("x" x " y" y " w470 BackgroundTrans", "关于")
        y += 30
        
        this.instance.SetFont(fonts.body)
        this.instance.AddGroupBox("x" x " y" y " w470 h55 BackgroundTrans", "")
        y += 18
        
        ; 作者信息
        this.instance.SetFont(fonts.h3)
        this.instance.AddText("x" (x + 15) " y" y " h24 +0x200 BackgroundTrans", "作者：洛迪")
        this.instance.SetFont(fonts.body)
        this.instance.AddButton("x+10 w50 h24 BackgroundTrans", "b站").OnEvent("Click", (*) => Run("https://space.bilibili.com/418324770"))
        this.instance.AddButton("x+10 w50 h24 BackgroundTrans", "爱发电").OnEvent("Click", (*) => Run("https://afdian.com/a/luodi"))
        this.instance.AddButton("x+10 w50 h24 BackgroundTrans", "赞助").OnEvent("Click", (*) => this.ShowSponsor())
        this.instance.AddButton("x+10 w50 h24 BackgroundTrans", "QQ群").OnEvent("Click", (*) => this.ShowQQGroup())
        this.instance.AddButton("x+10 w60 h24 BackgroundTrans", "视频教程").OnEvent("Click", (*) => msgbox("不好意思，还没做", "啊这.."))
    }

    ; 显示QQ群界面
    static ShowQQGroup() {
        qqGui := Gui("-Caption +Owner" this.instance.Hwnd)
        qqGui.BackColor := "181a1b"
        WinSetTransColor("181a1b", qqGui.Hwnd)
        
        ; 添加背景图片
        qqGui.AddPicture("x0 y0 w420 h548", "image/QR_code/QQ_QR_code.png")
        
        ; 添加复制群号按钮
        copyBtn := qqGui.AddButton("x267 y72 w66 h24 backgroundTrans", "复制群号")
        copyBtn.OnEvent("Click", (*) {
            A_Clipboard  := "922090138"
            ToolTip "群号已复制到剪贴板"
            Sleep 1000
            ToolTip
        })
        
        ; 添加关闭按钮
        closeBtn := qqGui.AddPicture("x370 y10 w40 h40 backgroundTrans", this.closeIcon).OnEvent("Click", (*) => qqGui.Destroy())
        ; 添加拖动区域
        dragArea := qqGui.AddPicture("x0 y0 w420 h65 backgroundTrans").OnEvent("Click", (*) => PostMessage(0xA1, 2))
        
        qqGui.Show("w420 h548")
    }
    
    ; 显示赞助页面
    static ShowSponsor() {
        sponsorGui := Gui("-Caption +Owner" this.instance.Hwnd)
        
        ; 添加背景图片
        sponsorGui.AddPicture("x0 y0 w476 h540", "image/QR_code/afdian_QR_code.jpg")
        
        sponsorGui.SetFont("s12 bold")
        sponsorGui.AddButton("x39 y161 w123 h49 BackgroundTrans", "前往爱发电主页")
            .OnEvent("Click", (*) => Run("https://afdian.com/a/luodi"))
        sponsorGui.AddButton("x39 y232 w123 h49 BackgroundTrans", "直达赞助地址")
            .OnEvent("Click", (*) => Run("https://ifdian.net/order/create?user_id=35b7fc88d0d911eb8e6952540025c377"))
        
        ; 添加关闭按钮
        closeBtn := sponsorGui.AddPicture("x433 y2 w40 h40 backgroundTrans", this.closeIcon).OnEvent("Click", (*) => sponsorGui.Destroy())
        ; 添加拖动区域
        dragArea := sponsorGui.AddPicture("x0 y0 w476 h100 backgroundTrans").OnEvent("Click", (*) => PostMessage(0xA1, 2))
        
        sponsorGui.Show("w476 h540")
    }
    ; 底部按钮
static AddBottomButtons(settingsMap) {
    btnWidth := 298
    spacing := 15
    
    y1 := 675
    y2 := y1 + 45
    
    totalWidth := 920
    startX := 40
    
    this.instance.AddText("x" startX " y" y1 " w" (btnWidth * 3 + spacing * 2) " h35 BackgroundTrans +0x1000 Center 0x200", "保存设置并重启")
    .OnEvent("Click", (*) => this.SaveAndReload(settingsMap))
    
this.instance.AddText("x" startX " y" y2 " w" btnWidth " h35 BackgroundTrans +0x1000 Center 0x200", "退出程序")
    .OnEvent("Click", (*) => ExitApp())
    
this.instance.AddText("x" (startX + btnWidth + spacing) " y" y2 " w" btnWidth " h35 BackgroundTrans +0x1000 Center 0x200", "打开Wplace")
    .OnEvent("Click", (*) => Run(_SettingsData.wplaceWeb))
    
this.instance.AddText("x" (startX + (btnWidth + spacing) * 2) " y" y2 " w" btnWidth " h35 BackgroundTrans +0x1000 Center 0x200", "确定")
    .OnEvent("Click", (*) => this.OnStartClick(settingsMap))
}
    ; 更换装饰图片
    static AddDecoration(x, y, w := 0, h := 0) {
        ; 自动获取image/meme文件夹下的所有图片文件
        pictures := []
        memeFolder := "image/meme/*.*"
        
        Loop Files, memeFolder {
            ; 只添加图片文件（jpg, jpeg, png, gif, bmp）
            if RegExMatch(A_LoopFileExt, "i)^(jpg|jpeg|png|gif|bmp)$")
                pictures.Push("image/meme/" A_LoopFileName)
        }
        
        ; 如果文件夹为空或没有找到图片，使用默认图片
        if pictures.Length = 0 
            return

        ; 定义宽高
        size := ""
        if w != 0
            size .= " w" w
        if h != 0
            size .= " h" h
        
        ; 随机选择一张图片
        this.instance.AddPicture("x" x " y" y size " BackgroundTrans", pictures[Random(1, pictures.Length)])
    }

    ; ====================================事件=====================================
    static Close() {
        try this.instance.Destroy()
        this.instance := false
    }

    static OnStartClick(settingsMap) {
        if this.HasUnsavedChanges(settingsMap) {
            res := MsgBox("设置已更改但未保存，是否保存？", "提示", "0x23 Owner" this.instance.Hwnd)
            switch res {
                case "Yes":
                    this.SaveAndReload(settingsMap)
                case "No":
                    this.Close()
                case "Cancel":
                    return
            }
        } else {
            this.Close()
        }
    }

    ; ====================================存储=====================================

    static GetSettingsMap() {
        return [
            { data: (&_SettingsData.openThisPageOnStart),         gui: "OpenThisPage" },
            { data: (&_SettingsData.openWplaceOnStart),           gui: "OpenWplace" },
            { data: (&_SettingsData.customUrl),                   gui: "CustomUrl" },
            { data: (&_SettingsData.openCustomOnStart),           gui: "OpenCustom" },
            { data: (&_SettingsData.menuKey),                     gui: "PauseKey" },
            { data: (&_SettingsData.fillKey.key),                 gui: "FillKey" },
            { data: (&_SettingsData.fillKey.mode),                gui: "FillKeyMode" },
            { data: (&_SettingsData.pickAndDrawKey.key),          gui: "PickKey" },
            { data: (&_SettingsData.pickAndDrawKey.mode),         gui: "PickKeyMode" },
            { data: (&_SettingsData.fillOnHoverPickOnClickKey.key), gui: "FhpcHk" },
            { data: (&_SettingsData.fillOnHoverPickOnClickKey.mode), gui: "FhpcHkMode" },
            { data: (&_SettingsData.DrawVerticalKey.key),         gui: "DrawVerticalKey" },
            { data: (&_SettingsData.DrawVerticalKey.mode),        gui: "DrawVerticalKeyMode" },
            { data: (&_SettingsData.DrawHorizontalKey.key),       gui: "DrawHorizontalKey" },
            { data: (&_SettingsData.DrawHorizontalKey.mode),      gui: "DrawHorizontalKeyMode" },
            { data: (&_SettingsData.moveStep),                    gui: "MoveStep" },
            { data: (&_SettingsData.pickDelay),                   gui: "PickDelay" },
            { data: (&_SettingsData.drawDelay),                   gui: "DrawDelay" },
            { data: (&_SettingsData.playSnd),                     gui: "PlaySnd" },
            { data: (&_SettingsData.playSndType),                 gui: "PlaySndType" },
            { data: (&_SettingsData.StatusTip.Horizontal),        gui: "StatusTip_Horizontal" },
            { data: (&_SettingsData.StatusTip.Vertical),          gui: "StatusTip_Vertical" },
            { data: (&_SettingsData.StatusTip.margin),            gui: "StatusTip_margin" },
            { data: (&_SettingsData.StatusTip.size),              gui: "StatusTip_size" },
            { data: (&_SettingsData.StatusTip.strokeWidth),       gui: "StatusTip_stroke_width" },
            { data: (&_SettingsData.StatusTip.alwaysDisplay),     gui: "StatusTip_always_display" }
        ]
    }

    static SaveAndReload(settingsMap) {
        for setting in settingsMap
            %setting.data% := this.instance[setting.gui].Value

        _SettingsData.triggerKey := ["LButton", "Space"][this.instance["TriggerKey"].Value]

        WplaceConfig.save()
        Reload()
    }

    static HasUnsavedChanges(settingsMap) {
        curTriggerKey := ["LButton", "Space"][this.instance["TriggerKey"].Value]

        for setting in settingsMap
            if %setting.data% != this.instance[setting.gui].Value
                return true

        if _SettingsData.triggerKey != curTriggerKey
            return true

        return false
    }
}
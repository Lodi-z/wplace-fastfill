class WplaceConfig {
    static file := "wplace_config.ini"
    static configs := false
    static Init() {
        this.configs := [
            ["Startup", "OpenThisPage", &_SettingsData.openThisPageOnStart],
            ["Startup", "OpenWplace", &_SettingsData.openWplaceOnStart],
            ["Startup", "CustomUrl", &_SettingsData.customUrl],
            ["Startup", "OpenCustom", &_SettingsData.openCustomOnStart],
            ["Hotkeys", "PauseKey", &_SettingsData.menuKey],
            ["Hotkeys", "FillKey", &_SettingsData.fillKey.key],
            ["Hotkeys", "FillKeyMode", &_SettingsData.fillKey.mode],
            ["Hotkeys", "PickKey", &_SettingsData.pickAndDrawKey.key],
            ["Hotkeys", "PickKeyMode", &_SettingsData.pickAndDrawKey.mode],
            ["Hotkeys", "FillOnHoverPickOnClickKey", &_SettingsData.fillOnHoverPickOnClickKey.key],
            ["Hotkeys", "FillOnHoverPickOnClickKeyMode", &_SettingsData.fillOnHoverPickOnClickKey.mode],
            ["Hotkeys", "DrawVerticalKey", &_SettingsData.DrawVerticalKey.key],
            ["Hotkeys", "DrawVerticalKeyMode", &_SettingsData.DrawVerticalKey.mode],
            ["Hotkeys", "DrawHorizontalKey", &_SettingsData.DrawHorizontalKey.key],
            ["Hotkeys", "DrawHorizontalKeyMode", &_SettingsData.DrawHorizontalKey.mode],
            ["Hotkeys", "TriggerKey", &_SettingsData.triggerKey],
            ["Other", "MoveStep", &_SettingsData.moveStep],
            ["Delay", "PickDelay", &_SettingsData.pickDelay],
            ["Delay", "DrawDelay", &_SettingsData.drawDelay],
            ["Other", "PlaySnd", &_SettingsData.playSnd],
            ["Other", "PlaySndType", &_SettingsData.playSndType],
            ["Other", "StatusTip_Horizontal", &_SettingsData.StatusTip.Horizontal],
            ["Other", "StatusTip_Vertical", &_SettingsData.StatusTip.Vertical],
            ["Other", "StatusTip_Margin", &_SettingsData.StatusTip.margin],
            ["Other", "StatusTip_Size", &_SettingsData.StatusTip.size],
            ["Other", "StatusTip_StrokeWidth", &_SettingsData.StatusTip.strokeWidth],
            ["Other", "StatusTip_AlwaysDisplay", &_SettingsData.StatusTip.alwaysDisplay]
        ]
        this.load()
    }
    static load() {
        for config in this.configs
            try %config[3]% := IniRead(this.file, config[1], config[2])
    }

    static save() {
        for config in this.configs
            IniWrite(%config[3]%, this.file, config[1], config[2])
    }
}
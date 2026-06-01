KeyMode := {
    heldDown: 1,
    toggle: 2,
    directly: 3
}
class KeyData {
    key := ""
    mode := 0
    __New(key, mode) {
        this.key := key
        this.mode := mode
    }
}
class SettingsData {
    openThisPageOnStart := true

    wplaceWeb := "https://wplace.live/"
    openWplaceOnStart := false

    customUrl := ""
    openCustomOnStart := false

    menuKey := "^Escape"
    fillKey := KeyData("z", KeyMode.heldDown)
    pickAndDrawKey := KeyData("x", KeyMode.directly)
    fillOnHoverPickOnClickKey := KeyData("c", KeyMode.toggle)
    DrawVerticalKey := KeyData("v", KeyMode.directly)
    DrawHorizontalKey := KeyData("h", KeyMode.directly)
    triggerKey := "LButton"

    moveStep := 8
    pickDelay := 100
    drawDelay := 10
    playSnd := false
    playSndType := 1
    StatusTip := {
        horizontal: 1,
        vertical: 3,
        margin: 20,
        size: 100,
        strokeWidth: 5,
        alwaysDisplay: true
    }
}

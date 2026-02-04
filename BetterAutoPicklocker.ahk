#SingleInstance Force
SetBatchLines, -1
SetMouseDelay, -1
SetKeyDelay, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

perfectColorHex := 0x7EE232 
whiteBarHex     := 0xFFFFFF 
stealingActive  := false
firstRun        := true

boxW := 650
boxH := 50
boxX := 0
boxY := 0

; adding tabs soon probally Main|Misc|Presets ect idrk
Gui, Main:New, +AlwaysOnTop, FEEFER
Gui, Main:Color, 1A1A1A 
Gui, Main:Font, s12 Bold cWhite, Segoe UI
Gui, Main:Add, Text, x15 y5 w280, --- FEEF AUTOPICKLOCKER ---
Gui, Main:Font, s10 Bold cWhite
Gui, Main:Add, Text, x15 y28 w280, --- MADE BY @SONOTCLOSE ---
Gui, Main:Font, s9 Norm cWhite
Gui, Main:Add, GroupBox, x10 y55 w310 h80, Mode Settings
Gui, Main:Add, Checkbox, x25 y80 vAutoPickToggle gTogglePick, AUTO PICKLOCK
Gui, Main:Add, Checkbox, x25 y105 vAlwaysResetPos Checked, Always Reset Pos
Gui, Main:Add, GroupBox, x10 y145 w310 h150, Optimization & Size
Gui, Main:Add, Text, x25 y170, Width:
Gui, Main:Add, Edit, x25 y190 vEditW w60 cBlack gUpdateSize, %boxW%
Gui, Main:Add, Text, x100 y170, Height:
Gui, Main:Add, Edit, x100 y190 vEditH w60 cBlack gUpdateSize, %boxH%
Gui, Main:Add, Text, x180 y170, Speed (ms):
Gui, Main:Add, Edit, x180 y190 vTrackSpeed w60 cBlack, 10
Gui, Main:Add, Text, x25 y225, Not Track Opacity:
Gui, Main:Add, Edit, x25 y245 vNotTrackTrans w60 cBlack, 38
Gui, Main:Add, Text, x180 y225, Track Opacity:
Gui, Main:Add, Edit, x180 y245 vTrackTrans w60 cBlack, 13
Gui, Main:Add, GroupBox, x10 y310 w310 h120, Positioning & Lock
Gui, Main:Add, Text, x25 y330, Box X Pos:
Gui, Main:Add, Edit, x25 y350 vEditX w60 cBlack, 0
Gui, Main:Add, Text, x100 y330, Box Y Pos:
Gui, Main:Add, Edit, x100 y350 vEditY w60 cBlack, 0
Gui, Main:Add, Checkbox, x180 y350 vLockMouse, Lock Mouse
Gui, Main:Add, Text, x25 y380, Lock X:
Gui, Main:Add, Edit, x25 y400 vLockX w60 cBlack, 0
Gui, Main:Add, Text, x100 y380, Lock Y:
Gui, Main:Add, Edit, x100 y400 vLockY w60 cBlack, 0
Gui, Main:Add, GroupBox, x10 y435 w310 h80, Extra Info
Gui, Main:Add, Checkbox, x25 y460 vEnableExtra, Enable Live Pos
Gui, Main:Font, s8 cGray
Gui, Main:Add, Text, x25 y485, Current Data: 
Gui, Main:Font, s8 cYellow
Gui, Main:Add, Text, vLiveStats x95 y485 w220, [ Q to Update ]
Gui, Main:Font, s9 Norm cWhite
Gui, Main:Add, GroupBox, x10 y525 w310 h60, Status
Gui, Main:Font, Bold
Gui, Main:Add, Text, vStatusText cRed x25 y550 w280, NOT TRACKING
Gui, Main:Font, Norm

Gui, Main:Show, w330 h600, THE LOCKSMITH
return
~q:: ; to knwo what ur placements are
Gui, Main:Submit, NoHide
if (EnableExtra) {
    MouseGetPos, curX, curY
    if WinExist("PlacementBox")
        WinGetPos, bX, bY,,, PlacementBox
    else
        bX := "None", bY := "None"
    
    ; forces the specific GUI and Control to refresh
    GuiControl, Main:, LiveStats, M:%curX%, %curY% | B:%bX%, %bY%
}
return

UpdateSize:
Gui, Submit, NoHide
boxW := EditW
boxH := EditH
if WinExist("PlacementBox")
    Gui, Checker:Show, w%boxW% h%boxH% NoActivate
return

TogglePick:
Gui, Submit, NoHide
if (AutoPickToggle) {
    if (AlwaysResetPos) { ; this can fuck up and have people bitching about there box is out of bounds idc
        boxX := (A_ScreenWidth / 2) - (boxW / 2)
        boxY := (A_ScreenHeight / 2) - (boxH / 2)
    } else {
        boxX := EditX
        boxY := EditY
    }
    
    GuiControl, Main:, EditX, %boxX%
    GuiControl, Main:, EditY, %boxY%
    
    Gui, Checker:Destroy
    Gui, Checker:New, -Caption +AlwaysOnTop +Border +LastFound
    Gui, Checker:Color, Red
    WinSet, Transparent, %NotTrackTrans%
    Gui, Checker:Show, w%boxW% h%boxH% x%boxX% y%boxY% NoActivate, PlacementBox
    
    GuiControl, Main:, StatusText, POSITIONING... ; todo fix this from getting stuck
    GuiControl, +cOrange, StatusText
} else {
    stealingActive := false
    SetTimer, MainLoop, Off
    Gui, Checker:Destroy
    GuiControl, Main:, StatusText, NOT TRACKING
    GuiControl, +cRed, StatusText
}
return

MainLoop:
if (!stealingActive)
    return
if (LockMouse)
    MouseMove, %LockX%, %LockY%, 0
P
PixelSearch, Gx, Gy, boxX, boxY, boxX+boxW, boxY+boxH, %perfectColorHex%, 5, Fast RGB ; find the perfect part and click when on it
if (ErrorLevel = 0) {
    PixelSearch, Wx, Wy, Gx-10, Gy-20, Gx+10, Gy+20, %whiteBarHex%, 15, Fast RGB
    if (ErrorLevel = 0) {
        Click 
        Sleep, 76
    }
}
return

^5:: 
Gui, Main:Submit, NoHide
if (!AutoPickToggle) 
    return 
stealingActive := false
SetTimer, MainLoop, Off
MouseGetPos, mX, mY
boxX := mX, boxY := mY
GuiControl, Main:, EditX, %boxX%
GuiControl, Main:, EditY, %boxY%
Gui, Checker:Destroy
Gui, Checker:New, -Caption +AlwaysOnTop +Border +LastFound
Gui, Checker:Color, Red
WinSet, Transparent, %NotTrackTrans%
Gui, Checker:Show, w%boxW% h%boxH% x%boxX% y%boxY% NoActivate, PlacementBox
GuiControl, Main:, StatusText, POSITIONING... ; need to fix this gets stuck if u move
GuiControl, +cOrange, StatusText
return

#IfWinExist, PlacementBox
Enter::
Gui, Main:Submit, NoHide
if (stealingActive) {
    stealingActive := false
    SetTimer, MainLoop, Off
    Gui, Checker:Color, Red
    WinSet, Transparent, %NotTrackTrans%
    GuiControl, Main:, StatusText, PAUSED (Red)
    GuiControl, +cOrange, StatusText
} else {
    WinGetPos, boxX, boxY, boxW, boxH, PlacementBox
    Gui, Checker:Color, Green
    WinSet, Transparent, %TrackTrans%
    stealingActive := true
    GuiControl, Main:, StatusText, TRACKING ACTIVE
    GuiControl, +cGreen, StatusText
    SetTimer, MainLoop, %TrackSpeed%
}
return
#IfWinActive

^!r::Reload

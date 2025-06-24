; AutoHotkey v2.0 Script for Teams Mute Toggle with Visual Indicator
#SingleInstance Force

; Create the GUI indicator
;myGui := Gui("+AlwaysOnTop +ToolWindow -Caption")
;myGui.BackColor := "FF0000"  ; Red background for muted
;myGui.SetFont("s10 Bold", "Arial")
;myGui.Add("Text", "cWhite", "MUTED")
;myGui.Show("NoActivate x10 y10 w80 h25")
;myGui.Hide()  ; Hide initially

; Hotkey to toggle mute in Teams (F9 key)
F9::ToggleTeamsMute()

ToggleTeamsMute() {
    ; Global variable to track mute state
    global TeamsIsMuted := false
    ; Store the current active window to return to it later
    PreviousWindow := WinGetTitle("A")
    PreviousWindowID := WinGetID("A")
    
    ; Check for different possible Teams process names
    teamsActive := false
    teamsExists := false
    teamsProcessName := ""
    
    ; Try different possible process names for Teams
    possibleProcesses := ["Teams.exe", "ms-teams.exe", "msteams.exe", "Microsoft Teams.exe"]
    
    ; First check if any Teams window is active
    for process in possibleProcesses {
        if WinActive("ahk_exe " process) {
            teamsActive := true
            teamsExists := true
            teamsProcessName := process
            break
        }
    }
    
    ; If no Teams window is active, check if any Teams process exists
    if (!teamsActive) {
        for process in possibleProcesses {
            if WinExist("ahk_exe " process) {
                teamsExists := true
                teamsProcessName := process
                break
            }
        }
    }
    
    ; Debug info
    ; TrayTip "Teams Detection", "Looking for Teams... Process found: " (teamsExists ? teamsProcessName : "None"), 1
    
    ; Now proceed with the mute toggle logic
    if (teamsActive) {
        ; Teams is already active, just send the mute shortcut
        Send "^+m"
        TeamsIsMuted := !TeamsIsMuted
        ;UpdateMuteState()
    }
    else if (teamsExists) {
        ; Teams exists but is not active, activate it first
        WinActivate "ahk_exe " teamsProcessName
        Sleep 200  ; Give Teams time to fully activate
        Send "^+m"
        TeamsIsMuted := !TeamsIsMuted
        ;UpdateMuteState()
    }
    else {
        ; Try one more approach - look for window titles containing "Teams"
        if WinExist("Microsoft Teams") || WinExist("Teams") {
            WinActivate
            Sleep 200
            Send "^+m"
            TeamsIsMuted := !TeamsIsMuted
            ;UpdateMuteState()
        }
        else {
            ;TrayTip "Teams Mute", "Microsoft Teams is not running", 2
            Return  ; Exit early as there's no need to restore focus
        }
    }
    
    ; Restore focus to the previous window
    Sleep 100  ; Small delay to ensure Teams processes the mute command
    WinActivate "ahk_id " PreviousWindowID
}

; Function to update the GUI and notifications based on mute state
;UpdateMuteState() {
;    if (TeamsIsMuted) {
        ;TrayTip "Teams Mute", "Microphone muted", 1
;        myGui.Show("NoActivate")  ; Show the mute indicator
;    } else {
        ;TrayTip "Teams Mute", "Microphone unmuted", 1
;        myGui.Hide()  ; Hide the mute indicator
;    }
;}

; Optional: Add a hotkey to manually toggle the indicator visibility
; Useful if the state gets out of sync with Teams
^F9:: {  ; Ctrl+F9
    TeamsIsMuted := !TeamsIsMuted
;    UpdateMuteState()
}

; Optional: Add a hotkey to exit the script
^!F9:: {  ; Ctrl+Alt+F9
;    myGui.Destroy()
    ExitApp
}

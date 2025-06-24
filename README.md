# TeamsToggleMute-AHK
AutoHotkey script to toggle Mute in Microsoft Teams

This script locates the current Teams window, gives it focus, sends a Mute command, then gives focus back to the application that was previously in focus.

An issue with the script is that as written it cannot easily differentiate between the main Teams window and an active Teams meeting. It seems to go to whichever was the last one the user interacted with.

TODO
- Add Camera toggle
- Add Leave meeting

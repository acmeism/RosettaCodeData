#i:: ; (Optional) Assigns a hotkey to display window info, Windows+i
MouseGetPos, x, y ; Gets x/y pos relative to active window
WinGetActiveTitle, WinTitle ; Gets active window title
Traytip, Mouse position, x: %x%`ny: %y%`rWindow: %WinTitle%, 4 ; Displays the info as a Traytip for 4 seconds
return

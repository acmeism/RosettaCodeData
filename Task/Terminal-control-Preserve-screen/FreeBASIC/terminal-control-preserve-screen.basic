'' 640x480x8, with 3 pages
Screen 12,,3
Windowtitle "Terminal control/Preserve screen"

'' text for working page #2 (visible page #0)
Screenset 2, 0
Cls
Print "This is the new screen, following a CLS"

'' text for working page #1 (visible page #0)
Screenset 1, 0
Cls
Print "This is the original screen"

' page #0 is the working page (visible page #0)
Screenset 0, 0

Screencopy 1, 0
Sleep 1000 '1 second
Screencopy 2, 0
Sleep 1000
Print
For i As Byte = 5 To 1 Step -1
    Print "Going back in: "; i
    Sleep 1000
Next i
Screencopy 1, 0
Sleep

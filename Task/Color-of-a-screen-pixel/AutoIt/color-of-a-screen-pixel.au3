Opt('MouseCoordMode',1)  ; 1 = (default) absolute screen coordinates
$pos = MouseGetPos()
$c   = PixelGetColor($pos[0], $pos[1])
ConsoleWrite("Color at x=" & $pos[0] & ",y=" & $pos[1] & _
		" ==> " & $c & " = 0x" & Hex($c) & @CRLF)

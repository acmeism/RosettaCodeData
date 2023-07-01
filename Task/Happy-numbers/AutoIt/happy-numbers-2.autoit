$c = 0
$k = 0
While $c < 8
	$a = ObjCreate("System.Collections.ArrayList")
	$k += 1
	$n = $k
	While $n <> 1
		If $a.Contains($n) Then
			ExitLoop
		EndIf
		$a.add($n)
		$s = StringSplit($n, "")
		$t = 0
		For $i = 1 To $s[0]
			$t += $s[$i] ^ 2
		Next
		$n = $t
	WEnd
	If $n = 1 Then
		ConsoleWrite($k & " is Happy" & @CRLF)
		$c += 1
	EndIf
	$a.Clear
WEnd

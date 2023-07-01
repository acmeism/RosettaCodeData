$c = 0
$k = 0
While $c < 8
	$k += 1
	$n = $k
	While $n <> 1
		$s = StringSplit($n, "")
		$t = 0
		For $i = 1 To $s[0]
			$t += $s[$i] ^ 2
		Next
		$n = $t
		Switch $n
			Case 4,16,37,58,89,145,42,20
			ExitLoop
		EndSwitch
	WEnd
	If $n = 1 Then
		ConsoleWrite($k & " is Happy" & @CRLF)
		$c += 1
	EndIf
WEnd

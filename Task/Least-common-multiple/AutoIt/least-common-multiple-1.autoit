Func _LCM($a, $b)
	Local $c, $f, $m = $a, $n = $b
	$c = 1
	While $c <> 0
		$f = Int($a / $b)
		$c = $a - $b * $f
		If $c <> 0 Then
			$a = $b
			$b = $c
		EndIf
	WEnd
	Return $m * $n / $b
EndFunc   ;==>_LCM

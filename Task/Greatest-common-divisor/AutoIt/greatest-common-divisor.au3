_GCD(18, 12)
_GCD(1071, 1029)
_GCD(3528, 3780)

Func _GCD($ia, $ib)
	Local $ret = "GCD of " & $ia & " : " & $ib & " = "
	Local $imod
	While True
		$imod = Mod($ia, $ib)
		If $imod = 0 Then Return ConsoleWrite($ret & $ib & @CRLF)
		$ia = $ib
		$ib = $imod
	WEnd
EndFunc   ;==>_GCD

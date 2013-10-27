Global $ackermann[2047][2047] ; Set the size to whatever you want
Func Ackermann($m, $n)
	If ($ackermann[$m][$n] <> 0) Then
		Return $ackermann[$m][$n]
	Else
		If ($m = 0) Then
			$return = $n + 1
		Else
			If ($n = 0) Then
				$return = Ackermann($m - 1, 1)
			Else
				$return = Ackermann($m - 1, Ackermann($m, $n - 1))
			EndIf
		EndIf
		$ackermann[$m][$n] = $return
		Return $return
	EndIf
EndFunc   ;==>Ackermann

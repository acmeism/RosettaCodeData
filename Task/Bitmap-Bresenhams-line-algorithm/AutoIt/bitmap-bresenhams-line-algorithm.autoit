Local $var = drawBresenhamLine(2, 3, 2, 6)

Func drawBresenhamLine($iX0, $iY0, $iX1, $iY1)
	Local $iDx = Abs($iX1 - $iX0)
	Local $iSx = $iX0 < $iX1 ? 1 : -1
	Local $iDy = Abs($iY1 - $iY0)
	Local $iSy = $iY0 < $iY1 ? 1 : -1
	Local $iErr = ($iDx > $iDy ? $iDx : -$iDy) / 2, $e2

	While $iX0 <= $iX1
		ConsoleWrite("plot( $x=" & $iX0 & ", $y=" & $iY0 & " )" & @LF)
		If ($iX0 = $iX1) And ($iY0 = $iY1) Then Return
		$e2 = $iErr
		If ($e2 > -$iDx) Then
			$iErr -= $iDy
			$iX0 += $iSx
		EndIf
		If ($e2 < $iDy) Then
			$iErr += $iDx
			$iY0 += $iSy
		EndIf
	WEnd
EndFunc   ;==>drawBresenhamLine

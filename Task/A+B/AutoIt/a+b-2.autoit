ConsoleWrite("# A+B:" & @CRLF)

Func Sum($inp)
	Local $num = StringSplit($inp, " "), $sum = 0
	For $i = 1 To $num[0]
;~ 		ConsoleWrite("# num["&$i&"]:" & $num[$i] & @CRLF)  ;;
		$sum = $sum + $num[$i]
	Next
	Return $sum
EndFunc ;==>Sum

$inp = "17  4"
$res = Sum($inp)
ConsoleWrite($inp & " --> " & $res & @CRLF)

$inp = "999 42 -999"
ConsoleWrite($inp & " --> " & Sum($inp) & @CRLF)

; In calculations, text counts as 0,
; so the program works correctly even with this input:
Local $inp = "999x y  42 -999", $res = Sum($inp)
ConsoleWrite($inp & " --> " & $res & @CRLF)

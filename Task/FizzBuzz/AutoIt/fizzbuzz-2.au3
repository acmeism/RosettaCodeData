#include <Constants.au3>

; uncomment how you want to do the output
Func Out($Msg)
	ConsoleWrite($Msg & @CRLF)

;~	FileWriteLine("FizzBuzz.Log", $Msg)

;~ 	$Btn = MsgBox($MB_OKCANCEL + $MB_ICONINFORMATION, "FizzBuzz", $Msg)
;~ 	If $Btn > 1 Then Exit	; Pressing 'Cancel'-button aborts the program
EndFunc   ;==>Out

Out("# FizzBuzz:")
For $i = 1 To 100
	If Mod($i, 15) = 0 Then
		Out("FizzBuzz")
	ElseIf Mod($i, 5) = 0 Then
		Out("Buzz")
	ElseIf Mod($i, 3) = 0 Then
		Out("Fizz")
	Else
		Out($i)
	EndIf
Next
Out("# Done.")

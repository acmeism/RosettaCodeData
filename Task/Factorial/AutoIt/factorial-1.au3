;AutoIt Version: 3.2.10.0
MsgBox (0,"Factorial",factorial(6))
Func factorial($int)
    If $int < 0 Then
      Return 0
   EndIf
   $fact = 1
   For $i = 1 To $int
        $fact = $fact * $i
   Next
   Return $fact
EndFunc

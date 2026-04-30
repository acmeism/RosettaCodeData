;AutoIt Version: 3.2.10.0
MsgBox (0,"Factorial",factorial(6))
Func factorial($int)
   if $int < 0 Then
      return 0
   Elseif $int == 0 Then
      return 1
   EndIf
   return $int * factorial($int - 1)
EndFunc

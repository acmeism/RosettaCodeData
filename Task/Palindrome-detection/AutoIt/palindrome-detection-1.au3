;== AutoIt Version: 3.3.8.1

Global $aString[7] = [ _
"In girum imus nocte, et consumimur igni", _  ; inexact palindrome
"Madam, I'm Adam.", _                         ; inexact palindrome
"salàlas", _                                  ; exact palindrome
"radar", _                                    ; exact palindrome
"Lagerregal", _                               ; exact palindrome
"Ein Neger mit Gazelle zagt im Regen nie.", _ ; inexact palindrome
"something wrong"]                            ; no palindrome
Global $sSpace42 = "                                          "

For $i = 0 To 6
	If _IsPalindrome($aString[$i]) Then
		ConsoleWrite('"' & $aString[$i] & '"' & StringLeft($sSpace42, 42-StringLen($aString[$i])) & 'is an exact palindrome.' & @LF)
	Else
		If _IsPalindrome( StringRegExpReplace($aString[$i], '\W', '') ) Then
			ConsoleWrite('"' & $aString[$i] & '"' & StringLeft($sSpace42, 42-StringLen($aString[$i])) & 'is an  inexact palindrome.' & @LF)
		Else
			ConsoleWrite('"' & $aString[$i] & '"' & StringLeft($sSpace42, 42-StringLen($aString[$i])) & 'is not a palindrome.' & @LF)
		EndIf
	EndIf
Next

Func _IsPalindrome($_string)
	Local $iLen = StringLen($_string)
	For $i = 1  To Int($iLen/2)
		If StringMid($_string, $i, 1) <> StringMid($_string, $iLen-($i-1), 1) Then Return False
	Next
	Return True
EndFunc

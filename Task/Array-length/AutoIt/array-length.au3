Opt('MustDeclareVars',1)	 	; 1 = Variables must be pre-declared.

Local $aArray[2] = ["Apple", "Orange"]
Local $Max = UBound($aArray)
ConsoleWrite("Elements in array: " & $Max & @CRLF)

For $i = 0 To $Max - 1
	ConsoleWrite("aArray[" & $i & "] = '" & $aArray[$i] & "'" & @CRLF)
Next

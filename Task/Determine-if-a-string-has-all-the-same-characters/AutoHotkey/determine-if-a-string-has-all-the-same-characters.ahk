testCases := ["", "   ", "2", "333", ".55", "tttTTT", "4444 4444k"]
for key, str in testCases {
	MsgBox % "Examining `'" str "`' which has a length of " StrLen(str) ":`n"
	if (StrLen(str) == 0) or (StrLen(str) == 1) {
		MsgBox % "  All characters in the string are the same.`n"
		continue
	}
	firstChar := SubStr(str, 1, 1)
	Loop, Parse, str
	{
		if (firstChar != A_LoopField) {
			hex := Format("0x{:x}", Ord(A_LoopField))
			MsgBox % "  Not all characters in the string are the same.`n  Character `'" A_LoopField "`' (" hex ") is different at position " A_Index ".`n", *
			break
		}
		if (A_Index = StrLen(str))
			MsgBox % "  All characters in the string are the same.`n", *
	}
}

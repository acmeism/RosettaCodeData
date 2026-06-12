for i, v in [10, "10",  12.345, "12.345", 12.3450, "12.3450"]
	output .= v " has " StrLen(StrSplit(v, ".").2) " decimals.`n"
MsgBox % output

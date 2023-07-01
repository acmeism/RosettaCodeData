FileRead, wList, % A_Desktop "\unixdict.txt"
result := ""
for i, v in Teacup_rim_text(wList)
	result .= v "`n"
MsgBox % result
return

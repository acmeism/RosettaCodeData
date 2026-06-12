str := "The quick brown fox jumps over the lazy dog"
for i, v in StrSplit("aeiou")
	str := StrReplace(str, v)
MsgBox % str

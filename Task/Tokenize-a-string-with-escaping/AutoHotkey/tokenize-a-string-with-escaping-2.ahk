str := "one^|uno||three^^^^|four^^^|^cuatro|"
for i, v in Tokenize(str, "|", "^")
	output .= i " : " v "`n"
MsgBox % output

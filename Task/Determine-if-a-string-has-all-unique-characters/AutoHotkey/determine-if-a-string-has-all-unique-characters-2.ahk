test := ["",".","abcABC","XYZ ZYX","1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"]
for i, v in test
	MsgBox % unique_characters(v)
return

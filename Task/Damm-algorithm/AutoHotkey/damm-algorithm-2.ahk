result := ""
for i, num in [5724, 5727, 112946, 112949]
	result .= num "`tis " (Damm(num) ? "valid" : "not valid") "`n"
MsgBox % result

output := ""
nums := ["978-0596528126","978-0596528120","978-1788399081","978-1788399083"]
for i, n in nums
	output .= ISBN13_check_digit(n) "`n"
MsgBox % output
return

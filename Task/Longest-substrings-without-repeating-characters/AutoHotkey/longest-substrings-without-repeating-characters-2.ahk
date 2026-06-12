db =
(
xyzyabcybdfd
xyzyab
zzz
a
)

for i, line in StrSplit(db, "`n", "`r"){
	result := "[", i := 0
	for str in LSWRC(line)
		result .= str ", "
	output .= line "`t> " Trim(result, ", ") "]`n"
}
MsgBox % output
return

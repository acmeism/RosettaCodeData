db =
(
three old rotators
never reverse
stable was I ere I saw elbatrosses
abracadabra
drome
x
the abbatial palace
)

for i, line in StrSplit(db, "`n", "`r"){
	result := "[""", i := 0
	for i, str in LPS(line)
		result .= str """, """
	output .= line "`t> " Trim(result, """, """) (i?"""":"") "]`n"
}
MsgBox % output
return

var =
(
Rosetta Code Phrase Reversal
)

array := strsplit(var, " ")

loop, % array.maxindex()
	string .= array[array.maxindex() - A_index + 1] . " "

loop, % array.maxindex()
{
	m := array[A_index]
	array2 := strsplit(m, "")
	Loop, % array2.maxindex()
		string2 .= array2[array2.maxindex() - A_index + 1]
	string2 .= " "
}

array := strsplit(string, " " )

loop, % array.maxindex()
{
	m := array[A_index]
	array3 := strsplit(m, "")
	Loop, % array3.maxindex()
		string3 .= array3[array3.maxindex() - A_index + 1]
	string3 .= " "
}

MsgBox % var . "`n" . string3 . "`n" . String . "`n" . string2
ExitApp

esc::ExitApp

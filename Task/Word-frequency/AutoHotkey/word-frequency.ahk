URLDownloadToFile, http://www.gutenberg.org/files/135/135-0.txt, % A_temp "\tempfile.txt"
FileRead, H, % A_temp "\tempfile.txt"
FileDelete,  % A_temp "\tempfile.txt"
words := []
while pos := RegExMatch(H, "\b[[:alpha:]]+\b", m, A_Index=1?1:pos+StrLen(m))
	words[m] := words[m] ? words[m] + 1 : 1
for word, count in words
	list .= count "`t" word "`r`n"
Sort, list, RN
loop, parse, list, `n, `r
{
	result .= A_LoopField "`r`n"
	if A_Index = 10
		break
}
MsgBox % "Freq`tWord`n" result
return

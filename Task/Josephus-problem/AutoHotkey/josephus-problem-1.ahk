; Since AutoHotkey is 1-based, we're numbering prisoners 1-41.
nPrisoners := 41
kth        := 3

; Build a list, purposefully ending with a separator
Loop % nPrisoners
	list .= A_Index . "|"

; iterate and remove from list
i := 1
Loop
{
	; Step by 2; the third step was done by removing the previous prisoner
	i += kth - 1
	if (i > nPrisoners)
		i := Mod(i, nPrisoners)
	; Remove from list
	end := InStr(list, "|", 0, 1, i)
	bgn := InStr(list, "|", 0, 1, i-1)
	list := SubStr(list, 1, bgn) . SubStr(list, end+1)
	nPrisoners--
}
Until (nPrisoners = 1)
MsgBox % RegExReplace(list, "\|") ; remove the final separator

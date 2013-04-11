nPrisoners := 41
kth        := 3
list       := []

; Build a list of 41 items
Loop % nPrisoners
	list.insert(A_Index)

; iterate and remove from list
i := 1
Loop
{
	; Step by 3
	i += kth - 1
	if (i > list.MaxIndex())
		i := Mod(i, list.MaxIndex())
	list.remove(i)
}
Until (list.MaxIndex() = 1)
MsgBox % list.1 ; there is only 1 element left

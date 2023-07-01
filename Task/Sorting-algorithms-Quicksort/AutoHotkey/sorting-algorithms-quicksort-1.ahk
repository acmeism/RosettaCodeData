a := [4, 65, 2, -31, 0, 99, 83, 782, 7]
for k, v in QuickSort(a)
	Out .= "," v
MsgBox, % SubStr(Out, 2)
return

QuickSort(a)
{
	if (a.MaxIndex() <= 1)
		return a
	Less := [], Same := [], More := []
	Pivot := a[1]
	for k, v in a
	{
		if (v < Pivot)
			less.Insert(v)
		else if (v > Pivot)
			more.Insert(v)
		else
			same.Insert(v)
	}
	Less := QuickSort(Less)
	Out := QuickSort(More)
	if (Same.MaxIndex())
		Out.Insert(1, Same*) ; insert all values of same at index 1
	if (Less.MaxIndex())
		Out.Insert(1, Less*) ; insert all values of less at index 1
	return Out
}

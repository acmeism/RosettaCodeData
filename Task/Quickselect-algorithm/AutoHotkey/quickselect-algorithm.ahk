MyList := [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
Loop, 10
	Out .= Select(MyList, 1, MyList.MaxIndex(), A_Index) (A_Index = MyList.MaxIndex() ? "" : ", ")
MsgBox, % Out
return

Partition(List, Left, Right, PivotIndex) {
	PivotValue := List[PivotIndex]
	, Swap(List, pivotIndex, Right)
	, StoreIndex := Left
	, i := Left - 1
	Loop, % Right - Left
		if (List[j := i + A_Index] <= PivotValue)
			Swap(List, StoreIndex, j)
			, StoreIndex++
	Swap(List, Right, StoreIndex)
	return StoreIndex
}

Select(List, Left, Right, n) {
	if (Left = Right)
		return List[Left]
	Loop {
		PivotIndex := (Left + Right) // 2
		, PivotIndex := Partition(List, Left, Right, PivotIndex)
		if (n = PivotIndex)
			return List[n]
		else if (n < PivotIndex)
			Right := PivotIndex - 1
		else
			Left := PivotIndex + 1
	}
}

Swap(List, i1, i2) {
	t := List[i1]
	, List[i1] := List[i2]
	, List[i2] := t
}

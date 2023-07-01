;-----------------------------------
Bell_triangle(maxRows){
	row := 1, col := 1, Arr := []
	Arr[row, col] := 1
	while (Arr.Count() < maxRows){
		row++
		max := Arr[row-1].Count()
		Loop % max{
			if (col := A_Index) =1
				Arr[row, col] := Arr[row-1, max]
			Arr[row, col+1] := Arr[row, col] + Arr[row-1, col]
		}
	}
	return Arr
}
;-----------------------------------
Show_Bell_Number(Arr){
	for i, obj in Arr{
		res .= obj.1 "`n"
	}
	return Trim(res, "`n")
}
;-----------------------------------
Show_Bell_triangle(Arr){
	for i, obj in Arr{
		for j, v in obj
			res .= v ", "
		res := Trim(res, ", ") . "`n"
	}
	return Trim(res, "`n")
}
;-----------------------------------

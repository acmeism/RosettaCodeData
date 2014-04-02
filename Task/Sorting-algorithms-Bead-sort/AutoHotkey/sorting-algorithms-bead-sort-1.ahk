BeadSort(data){
	Pole:=[]	, TempObj:=[], Result:=[]
	for, i, v in data {
		Row := i
		loop, % v
			MaxPole := MaxPole>A_Index?MaxPole:A_Index	, Pole[A_Index, row] := 1
	}

	for i , obj in Pole {
		TempVar:=0	,	c := A_Index
		for n, v in obj
			TempVar += v
		loop, % TempVar
			TempObj[c, A_Index] := 1
	}

	loop, % Row {
		TempVar:=0	,	c := A_Index
		Loop, % MaxPole
			TempVar += TempObj[A_Index,c]
		Result[c] := TempVar
	}
	return Result
}

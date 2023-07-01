n := 5
MsgBox, 262144, ,% ""
. "Pascal upper-triangular :`n" show(Pascal_Upper(n))
. "`n`nPascal lower-triangular :`n" show(Pascal_Lower(n))
. "`n`nPascal symmetric:`n" show(Pascal_Symm(n))
return

show(obj){
	for i, o in obj{
		line := ""
		for j, v in o
			line .= v ", "
		res .= "[" Trim(line, ", ") "]`n,"
	}
	return "[" Trim(res, "`n,") "]"
}

Pascal_Upper(n){
	obj := fillObj(n)
	loop % n
		obj[1, A_Index] := 1
	loop % n-1
		obj[A_Index+1, 1] := 0
	for i, o in obj
		for j, v in o
			if !(i = 1 or j = 1)
				obj[i, j] := obj[i, j-1] + obj[i-1, j-1]
	return obj
}

Pascal_Lower(n){
	obj := fillObj(n)
	loop % n
		obj[A_Index, 1] := 1
	loop % n-1
		obj[1, A_Index+1] := 0
	for i, o in obj
		for j, v in o
			if !(i = 1 or j = 1)
				obj[i, j] := obj[i-1, j] + obj[i-1, j-1]
	return obj
}

Pascal_Symm(n){
	obj := fillObj(n)
	loop % n
		obj[A_Index, 1] := 1
	loop % n-1
		obj[1, A_Index+1] := 1
	for i, o in obj
		for j, v in o
			if !(i = 1 or j = 1)
				obj[i, j] := obj[i-1, j] + obj[i, j-1]
	return obj
}

fillObj(n){
	obj := []
	loop % n{
		i := A_Index
		loop % n
			obj[i, A_Index] := 0
	}
	return obj
}

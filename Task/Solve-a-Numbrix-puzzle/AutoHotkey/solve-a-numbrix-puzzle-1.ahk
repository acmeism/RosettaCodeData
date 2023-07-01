SolveNumbrix(Grid, Locked, Max, row, col, num:=1, R:="", C:=""){
	if (R&&C)							; if neighbors (not first iteration)
	{
		Grid[R, C] := ">" num 					; place num in current neighbor and mark it visited ">"
		row:=R, col:=C						; move to current neighbor
	}

	num++								; increment num
	if (num=max)							; if reached end
		return map(Grid)					; return solution

	if locked[num]							; if current num is a locked value
	{
		row := StrSplit((StrSplit(locked[num], ",").1) , ":").1	; find row of num
		col := StrSplit((StrSplit(locked[num], ",").1) , ":").2	; find col of num
		if SolveNumbrix(Grid, Locked, Max, row, col, num)	; solve for current location and value
			return map(Grid)				; if solved, return solution
	}
	else
	{
		for each, value in StrSplit(Neighbor(row,col), ",")
		{
			R := StrSplit(value, ":").1
			C := StrSplit(value, ":").2

			if (Grid[R,C] = "")				; a hole or out of bounds
			|| InStr(Grid[R, C], ">")			; visited
			|| Locked[num+1] && !(Locked[num+1]~= "\b" R ":" C "\b") ; not neighbor of locked[num+1]
			|| Locked[num-1] && !(Locked[num-1]~= "\b" R ":" C "\b") ; not neighbor of locked[num-1]
			|| Locked[num]					; locked value
			|| Locked[Grid[R, C]]				; locked cell
				continue

			if SolveNumbrix(Grid, Locked, Max, row, col, num, R, C)	; solve for current location, neighbor and value
				return map(Grid)			; if solved, return solution
		}
	}
	num--								; step back
	for i, line in Grid
		for j, element in line
			if InStr(element, ">") && (StrReplace(element, ">") >= num)
				Grid[i, j] := 0
}
;--------------------------------
;--------------------------------
;--------------------------------
Neighbor(row,col){
	return row-1 ":" col
	. "," row+1 ":" col
	. "," row ":" col+1
	. "," row ":" col-1
}
;--------------------------------
map(Grid){
	for i, row in Grid
	{
		for j, element in row
			line .= (A_Index > 1 ? "`t" : "") . element
		map .= (map<>""?"`n":"") line
		line := ""
	}
	return StrReplace(map, ">")
}

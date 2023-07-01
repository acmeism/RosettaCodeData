;--------------------------------
Grid := [[ "Y"	, 33	, 35	, "Y"	, "Y"]
	,[ "Y"	, "Y"	, 24	, 22	, "Y"]
	,[ "Y"	, "Y"	, "Y"	, 21	, "Y"	, "Y"]
	,[ "Y"	, 26	, "Y"	, 13	, 40	, 11 ]
	,[ 27	, "Y"	, "Y"	, "Y"	, 9	, "Y"	, 1  ]
	,[ ""	, ""	, "Y"	, "Y"	, 18	, "Y"	, "Y"]
	,[ ""	, ""	, ""	, ""	, "Y"	, 7	, "Y"	, "Y"]
	,[ ""	, ""	, ""	, ""	, ""	, ""	, 5	, "Y"]]
;--------------------------------
; find locked cells, find row and col of first value "1" and max value
Locked := []
for i, line in Grid
	for j, element in line
	{
		if element = 1
			row :=i , col := j
		if element is integer
			Locked[element] := i ":" j "," Neighbor(i, j)	; save locked elements position and neighbors
			, max := element > max ? element : max		; find max value
	}
;--------------------------------
MsgBox, 262144, ,% SolveHidato(Grid, Locked, Max, row, col)
return

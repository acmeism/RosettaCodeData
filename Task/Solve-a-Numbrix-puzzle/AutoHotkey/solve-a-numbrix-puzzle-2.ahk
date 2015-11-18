;--------------------------------
Grid := [[0,	0,	0,	0,	0,	0,	0,	0,	0]
	,[0,	0,	46,	45,	0,	55,	74,	0,	0]
	,[0,	38,	0,	0,	43,	0,	0,	78,	0]
	,[0,	35,	0,	0,	0,	0,	0,	71,	0]
	,[0,	0,	33,	0,	0,	0,	59,	0,	0]
	,[0,	17,	0,	0,	0,	0,	0,	67,	0]
	,[0,	18,	0,	0,	11,	0,	0,	64,	0]
	,[0,	0,	24,	21,	0,	1,	2,	0,	0]
	,[0,	0,	0,	0,	0,	0,	0,	0,	0]]
;--------------------------------
; find locked cells, find row and col of first value "1" and max value
Locked := []
max := 1
for i, line in Grid
	for j, element in line
	{
		max ++
		if element = 1
			row :=i , col := j
		if (element > 0)
			Locked[element] := i ":" j "," Neighbor(i, j)	; save locked elements position and neighbors
			
	}
;--------------------------------
MsgBox, 262144, ,% SolveNumbrix(Grid, Locked, Max, row, col)
return

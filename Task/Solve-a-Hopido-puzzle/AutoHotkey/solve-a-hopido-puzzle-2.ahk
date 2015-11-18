;--------------------------------
Grid := [["",0 ,0 ,"",0 ,0 ,""]
	,[0 ,0 ,0 ,0 ,0 ,0 ,0]
	,[0 ,0 ,0 ,0 ,0 ,0 ,0]
	,["",0 ,0 ,0 ,0 ,0 ,""]
	,["","",0 ,0 ,0 ,"",""]
	,["","","",0 ,"","",""]]
;--------------------------------
; find locked cells, find max value
Locked := []
max := 1
for i, line in Grid
	for j, element in line
		if (element >= 0)
			max++ 	, list .= i ":" j "`n"
	
random, rnd, 1, %max%
loop, parse, list, `n, `r
	if (A_Index = rnd)
	{
		row := StrSplit(A_LoopField, ":").1
		col := StrSplit(A_LoopField, ":").2
		Grid[row,col] := 1
		Locked[1] := row ":" col "," Neighbor(row, col)
		break
	}
;--------------------------------
MsgBox, 262144, ,% SolveHopido(Grid, Locked, Max, row, col)
return

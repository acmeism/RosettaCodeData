oGrid := [[ "", "X", "X"]							; setup oGrid
	,[ "X", "X", "X", "X"]
	,[  "", "X", "X"]]

oNeighbor := [], oCell := [], 	oRoute := [] , oVisited := []			; initialize objects

for row, oRow in oGrid
	for col, val in oRow
		if val								; for each valid cell in oGrid
			oNeighbor[row, col] := Neighbors(row, col, oGrid)	; list valid no-connection neighbors

Solve:
for row, oRow in oGrid
	for col , val in oRow
		if val								; for each valid cell in oGrid
			if (oSolution := SolveNoConnect(row, col, 1)).8		; solve for this cell
				break, Solve					; if solution found stop

; show solution
for i , val in oSolution
	oCell[StrSplit(val, ":").1 , StrSplit(val, ":").2] := i

		  A := oCell[1, 2]	, B := oCell[1, 3]
C := oCell[2, 1], D := oCell[2, 2]	, E := oCell[2, 3], 	F := oCell[2, 4]
		  G := oCell[3, 2]	, H := oCell[3, 3]
sol =
(

    %A%   %B%
   /|\ /|\
  / | X | \
 /  |/ \|  \
%C% - %D% - %E% - %F%
 \  |\ /|  /
  \ | X | /
   \|/ \|/
    %G%   %H%
)
MsgBox % sol
return
;-----------------------------------------------------------------------
SolveNoConnect(row, col, val){
	global
	oRoute.push(row ":" col)						; save route
	oVisited[row, col] := true						; mark this cell visited
	
	if oRoute[8]								; if solution found
		return true							; end recursion

	for each, nn in StrSplit(oNeighbor[row, col], ",") 			; for each no-connection neighbor of cell
	{
		rowX := StrSplit(nn, ":").1	, colX := StrSplit(nn, ":").2	; get coords of this neighbor
		if !oVisited[rowX, colX]					; if not previously visited
		{
			oVisited[rowX, colX] := true				; mark this cell visited
			val++							; increment
			if (SolveNoConnect(rowX, colX, val))			; recurse
				return oRoute					; if solution found return route
		}
	}
	oRoute.pop()								; Solution not found, backtrack oRoute
	oVisited[row, col] := false						; Solution not found, remove mark
}
;-----------------------------------------------------------------------
Neighbors(row, col, oGrid){							; return distant neighbors of oGrid[row,col]
	for r , oRow in oGrid
		for c, v in oRow
			if (v="X") && (abs(row-r) > 1 || abs(col-c) > 1)
				list .= r ":"c ","
	if (row<>2) && oGrid[row, col]
		list .= oGrid[row, col+1] ? row ":" col+1 "," : oGrid[row, col-1] ? row ":" col-1 "," : ""
	return Trim(list, ",")
}

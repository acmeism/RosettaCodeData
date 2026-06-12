gridSize := 10

grid := []
loop % gridSize {
    row := A_Index
    loop % gridSize {
        col := A_Index
        grid[row, col] := Min(row, col, gridSize+1-row, gridSize+1-col) - 1
    }
}

for row, obj in Grid {
    for col, v in obj
        result .= v "  "
    result .= "`n"
}
MsgBox % result

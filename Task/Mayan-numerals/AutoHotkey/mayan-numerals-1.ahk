MayanNumerals(num){
	pwr:=1, obj:=[], grid:=[]
	while (num // 20**pwr)
		pwr++	
	while --pwr
	{
		obj.Push(num // 20**pwr)
		num := Mod(num, 20**pwr)
	}
	obj.Push(num)
	cols := obj.count()
	loop % cols
	{
		c := A_Index
		loop 4
			grid[c, A_Index] := "    "
		grid[c, 4] := " Θ  "
	}
	
	for i, v in obj
	{
		j := 5
		loop % v//5
		{
			j := 5 - A_Index
			grid[i, j] := "————"
		}
		rem := ""
		loop % Mod(v, 5)
			rem .= "●"
		rem := rem = "●" ? " ●  " : rem = "●●" ? " ●● " : rem = "●●●" ? "●●● " : rem
		if Mod(v, 5)
			grid[i, j-1] := rem
	}
	return grid2table(grid, cols)
}

grid2table(grid, cols){
	loop, % cols-1
		topRow .= "════╦", bottomRow .= "════╩"
	topRow := "╔" topRow "════╗"
	bottomRow := "╚" bottomRow "════╝"
	loop % 4
	{
		r := A_Index
		loop % cols
			result .= "║" grid[A_Index, r]
		result .= "║`n"
	}
	result := topRow "`n" result . bottomRow
	return % result
}

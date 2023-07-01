; Test parameters
max := 20, fizz := 3, buzz := 5, baxx := 7

Loop % max {
	output := ""
	if (Mod(A_Index, fizz) = 0)
		output .= "Fizz"
	if (Mod(A_Index, buzz) = 0)
		output .= "Buzz"
	if (Mod(A_Index, baxx) = 0)
		output .= "Baxx"
	if (output = "")
		FileAppend %A_Index%`n, *
	else
		FileAppend %output%`n, *
}

SetBatchLines -1

InputBox, Enter_value, Enter the no. of lines sought
array := []
Loop, % 2*Enter_value - 1
	Loop, % x := A_Index
		y := A_Index, Array[x, y] := 1

x := 3

Loop
{
	base_r := x - 1
	, x++
	, y := 2
	, index := x
	, new := 1
	
	Loop, % base_r - 1
	{
		array[x, new+1] := array[x-1, new] + array[base_r, y]
		, x++
		, new ++
		, y++
	}
	x := index
	If ( mod(x,2) = 0 )
	{
		to_run := floor(x - x/2)
		, y2 := to_run + 1
	}
	Else
	{
		to_run := x - floor(x/2)
		, y2 := to_run
	}
	Loop, % to_run
	{
		array[x, y2] := array[x-1, y2-1]
		, y2++
		If ( y2 = Enter_value + 1 ) && ( x = Enter_value )
		{
			Loop, % Enter_value
			{
				Loop, % x11 := A_Index
				{
					y11 := A_Index
					, string2 .= " " array[x11, y11]
				}
				string2 .= "`n"
			}
			MsgBox % string2
			ExitApp
		}
	}
}

~Esc::ExitApp

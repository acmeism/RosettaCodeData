string =
(
-2 0 -2 5 5 3 -1 -3 5 5 0 2 -4 4 2
)
string2 := string
Loop
{
	loop, parse, string, %A_space%
	{
		list := 1 = A_index ? A_loopfield : list
		StringSplit, k, list, %A_space%

		if ( k%k0% <= A_loopfield ) && ( l != "" ) && ( A_index != 1 )
			list := list . " " . A_loopfield

		if ( k%k0% > A_loopfield )
			list := A_loopfield . " " . list , index++
		l := A_loopfield
	}		
		if ( index = 0 )
		{
			MsgBox % "unsorted:" string2 "`n    Sorted:" list
			exitapp
		}
		string := list, list = "", index := 0
	}
esc::ExitApp

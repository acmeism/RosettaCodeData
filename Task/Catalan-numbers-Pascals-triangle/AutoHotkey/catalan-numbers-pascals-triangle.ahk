/* Generate Catalan Numbers
//
// smgs: 20th Feb, 2014
*/
Array := [], Array[2,1] := Array[2,2] := 1 ; Array inititated and 2nd row of pascal's triangle assigned
INI := 3 ; starts with calculating the 3rd row and as such the value
Loop, 31 ; every odd row is taken for calculating catalan number as such to obtain 15 we need 2n+1
{
	if ( A_index > 2 )
	{
		Loop, % A_INDEX
		{
			old := ini-1, 		index := A_index, 		index_1 := A_index + 1
			Array[ini, index_1] := Array[old, index] + Array[old, index_1]
			Array[ini, 1] := Array[ini, ini] := 1
			line .= Array[ini, A_index] " "
		}
	;~ MsgBox % line ; gives rows of pascal's triangle
	; calculating every odd row starting from 1st so as to obtain catalan's numbers
		if ( mod(ini,2) != 0)
		{
			StringSplit, res, line, %A_Space%
			ans := res0//2, ans_1 := ans++
			result := result . res%ans_1% - res%ans% " "
		}
	line :=
	ini++
	}
}
MsgBox % result

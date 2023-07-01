Msgbox % format(pascalstriangle())
Return

format(o) ; converts object to string
{
	For k, v in o
		s .= IsObject(v) ? format(v) "`n" : v " "
	Return s
}
pascalstriangle(n=7) ; n rows of Pascal's triangle
{
	p := Object(), z:=Object()
	Loop, % n
		Loop, % row := A_Index
			col := A_Index
			, p[row, col] := row = 1 and col = 1
				? 1
				: (p[row-1, col-1] = "" ; math operations on blanks return blanks; I want to assume zero
					? 0
					: p[row-1, col-1])
				+ (p[row-1, col] = ""
					? 0
					: p[row-1, col])
	Return p
}

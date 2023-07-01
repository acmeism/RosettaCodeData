res := Primitive_Heronian_triangles(200)
loop, parse, res, `n, `r
{
	if A_Index<=10
		res2.= A_LoopField "`n"
	if StrSplit(A_LoopField, "`t").1 = 210
		res3.= A_LoopField "`n"
	Counter := A_Index
}

MsgBox % Counter " results found"
. "`n`nFirst 10 results:"
. "`n" "Area`tPerimeter`tSides`n" res2
. "`nResults for Area = 210:"
. "`n" "Area`tPerimeter`tSides`n" res3
return

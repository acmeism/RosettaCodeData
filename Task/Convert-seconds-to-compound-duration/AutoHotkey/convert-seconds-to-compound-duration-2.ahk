data=
(
7259
86400
6000000
)

loop, parse, data, `n, `r
	res .= A_LoopField "`t: " duration(A_LoopField) "`n"
MsgBox % res
return

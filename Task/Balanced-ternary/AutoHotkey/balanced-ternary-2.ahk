data =
(
523
-436
65
-262023
)
loop, Parse, data, `n
	result .= A_LoopField " : " BalancedTernary(A_LoopField) "`n"
MsgBox % result
return

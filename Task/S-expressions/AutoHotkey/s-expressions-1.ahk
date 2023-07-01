S_Expressions(Str){
	Str := RegExReplace(Str, "s)(?<![\\])"".*?[^\\]""(*SKIP)(*F)|((?<![\\])[)(]|\s)", "`n$0`n")
	Str := RegExReplace(Str, "`am)^\s*\v+")	,	Cnt := 0
	loop, parse, Str, `n, `r
	{
		Cnt := A_LoopField=")" ? Cnt-1 : Cnt
		Res .= tabs(Cnt) A_LoopField "`r`n"
		Cnt := A_LoopField="(" ? Cnt+1 : Cnt
	}
	return Res
}
tabs(n){
	loop, % n
		Res .= "`t"
	return Res
}

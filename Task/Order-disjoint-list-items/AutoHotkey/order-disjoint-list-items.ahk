Data := [ {M: "the cat sat on the mat", N: "mat cat"}
	, {M: "the cat sat on the mat", N: "cat mat"}
	, {M: "A B C A B C A B C", N: "C A C A"}
	, {M: "A B C A B D A B E", N: "E A D A"}
	, {M: "A B", N: "B"}
	, {M: "A B", N: "B A"}
	, {M: "A B B A", N: "B A"} ]

for Key, Val in Data
	Output .= Val.M " :: " Val.N " -> " OrderDisjointList(Val.M, Val.N) "`n"
MsgBox, % RTrim(Output, "`n")

OrderDisjointList(M, N) {
	ItemsN := []
	Loop, Parse, N, % A_Space
		ItemsN[A_LoopField] := ItemsN[A_LoopField] ? ItemsN[A_LoopField] + 1 : 1
	N := StrSplit(N, A_Space)
	Loop, Parse, M, % A_Space
		Result .= (ItemsN[A_LoopField]-- > 0 ? N.Remove(1) : A_LoopField) " "
	return RTrim(Result)
}

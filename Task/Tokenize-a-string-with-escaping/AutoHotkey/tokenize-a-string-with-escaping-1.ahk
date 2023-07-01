Tokenize(s,d,e){
	for i,v in x:=StrSplit(StrReplace(StrReplace(StrReplace(s,e e,Chr(0xFFFE)),e d,Chr(0xFFFF)),e),d)
		x[i]:=StrReplace(StrReplace(v,Chr(0xFFFE),e),Chr(0xFFFF),d)
	return x
}

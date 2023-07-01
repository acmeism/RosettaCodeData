Menu(list:=""){
	if !list			; if called with an empty list
		return			; return an empty string
	for i, v in x := StrSplit(list, "`n", "`r")
		string .= (string?"`n":"") i "- " v
		, len := StrLen(v) > len ? StrLen(v) : len
	while !x[Choice]
		InputBox , Choice, Please Select From Menu, % string ,, % 200<len*7 ? 200 ? len*7 , % 120 + x.count()*20
	return x[Choice]
}

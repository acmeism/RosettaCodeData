collapsible_string(str){
	for i, ch in StrSplit(str){
		if (ch <> prev)
			res .= ch
		prev := ch
	}
	return "original string:`t" StrLen(str) " characters`t«««" str "»»»`nresultant string:`t" StrLen(res) " characters`t«««" res "»»»"
}

MTF_Encode(string){
	str := "abcdefghijklmnopqrstuvwxyz"
	loop, parse, string
		code .= (A_Index>1 ? ",":"") . InStr(str, A_LoopField) - 1	, str := A_LoopField . StrReplace(str, A_LoopField)
	return code
}

MTF_Decode(code){
	str := "abcdefghijklmnopqrstuvwxyz"
	loop, parse, code, `,
		string .= (letter := SubStr(str, A_LoopField+1, 1)) 		, str := letter . StrReplace(str, letter)
	return string
}

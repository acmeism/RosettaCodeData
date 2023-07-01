isWordPossible(blocks, word){
	o := {}
	loop, parse, blocks, `n, `r
		o.Insert(A_LoopField)
	loop, parse, word
		if !(r := isWordPossible_contains(o, A_LoopField, word))
			return 0
	return 1
}
isWordPossible_contains(byref o, letter, word){
	loop 2 {
		for k,v in o
			if Instr(v,letter)
			{
				StringReplace, op, v,% letter
				if RegExMatch(op, "[" word "]")
					sap := k
				else added := 1 , sap := k
				if added
					return "1" o.remove(sap)
			}
		added := 1
	}
}

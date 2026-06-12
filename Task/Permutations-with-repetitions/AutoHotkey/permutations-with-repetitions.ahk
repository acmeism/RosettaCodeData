P(n,k="",opt=0,delim="",str="") { ; generate all n choose k permutations lexicographically
	;1..n = range, or delimited list, or string to parse
	;	to process with a different min index, pass a delimited list, e.g. "0`n1`n2"
	;k = length of result
	;opt 0 = no repetitions
	;opt 1 = with repetitions
	;opt 2 = run for 1..k
	;opt 3 = run for 1..k with repetitions
	;str = string to prepend (used internally)
	;returns delimited string, error message, or (if k > n) a blank string
	i:=0
	If !InStr(n,"`n")
		If n in 2,3,4,5,6,7,8,9
			Loop, %n%
				n := A_Index = 1 ? A_Index : n "`n" A_Index
		Else
			Loop, Parse, n, %delim%
				n := A_Index = 1 ? A_LoopField : n "`n" A_LoopField
	If (k = "")
		RegExReplace(n,"`n","",k), k++
	If k is not Digit
		Return "k must be a digit."
	If opt not in 0,1,2,3
		Return "opt invalid."
	If k = 0
		Return str
	Else
		Loop, Parse, n, `n
			If (!InStr(str,A_LoopField) || opt & 1)
				s .= (!i++ ? (opt & 2 ? str "`n" : "") : "`n" )
					. P(n,k-1,opt,delim,str . A_LoopField . delim)
		Return s
}

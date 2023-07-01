Four_is_magic(num){
	nubmer := num
	while (num <> 4)
		result .= (res := spell(num)) " is " spell(num := StrLen(res)) ", "
	return PrettyNumber(nubmer) "  " result "four is magic!"
}
Spell(n) { ; recursive function to spell out the name of a max 36 digit integer, after leading 0s removed
	Static p1=" thousand ",p2=" million ",p3=" billion ",p4=" trillion ",p5=" quadrillion ",p6=" quintillion "
		 , p7=" sextillion ",p8=" septillion ",p9=" octillion ",p10=" nonillion ",p11=" decillion "
		 , t2="twenty",t3="thirty",t4="forty",t5="fifty",t6="sixty",t7="seventy",t8="eighty",t9="ninety"
		 , o0="zero",o1="one",o2="two",o3="three",o4="four",o5="five",o6="six",o7="seven",o8="eight"
		 , o9="nine",o10="ten",o11="eleven",o12="twelve",o13="thirteen",o14="fourteen",o15="fifteen"
		 , o16="sixteen",o17="seventeen",o18="eighteen",o19="nineteen"
	If (11 < d := (StrLen(n)-1)//3)		; #of digit groups of 3
		Return "Number too big"
	If (d)								; more than 3 digits
		Return Spell(SubStr(n,1,-3*d)) p%d% ((s:=SubStr(n,1-3*d)) ? ", " Spell(s) : "")
	i := SubStr(n,1,1)
	If (n > 99)							; 3 digits
		Return o%i% " hundred" ((s:=SubStr(n,2)) ? " " Spell(s) : "")
	If (n > 19)							; n = 20..99
		Return t%i% ((o:=SubStr(n,2)) ? "-" o%o% : "")
	Return o%n%							; n = 0..19
}
PrettyNumber(n) { ; inserts thousands separators into a number string
    Return RegExReplace(n, "\B(?=((\d{3})+$))", ",")
}

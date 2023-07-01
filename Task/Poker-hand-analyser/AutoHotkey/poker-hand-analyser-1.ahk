PokerHand(hand){
	StringUpper, hand, hand
	Sort, hand, FCardSort D%A_Space%
	cardSeq	:= RegExReplace(hand, "[^2-9TJQKA]")
	Straight:= InStr("23456789TJQKA", cardSeq) || (cardSeq = "2345A") ? true : false	
	hand 	:= cardSeq = "2345A" ? RegExReplace(hand, "(.*)\h(A.)", "$2 $1") : hand
	Royal 	:= InStr(hand, "A") ? "Royal": "Straight"
	return  (hand ~= "[2-9TJQKA](.)\h.\1\h.\1\h.\1\h.\1") && (Straight) 			? hand "`t" Royal " Flush"
			: (hand ~= "([2-9TJQKA]).*?\1.*?\1.*?\1") 				? hand "`tFour of a Kind"
			: (hand ~= "^([2-9TJQKA]).\h\1.\h(?!\1)([2-9TJQKA]).\h\2.\h\2.$") 	? hand "`tFull House"	; xxyyy
			: (hand ~= "^([2-9TJQKA]).\h\1.\h\1.\h(?!\1)([2-9TJQKA]).\h\2.$") 	? hand "`tFull House"	; xxxyy
			: (hand ~= "[2-9TJQKA](.)\h.\1\h.\1\h.\1\h.\1") 			? hand "`tFlush"
			: (Straight)								? hand "`tStraight"
			: (hand ~= "([2-9TJQKA]).*?\1.*?\1")					? hand "`tThree of a Kind"
			: (hand ~= "([2-9TJQKA]).\h\1.*?([2-9TJQKA]).\h\2")			? hand "`tTwo Pair"
			: (hand ~= "([2-9TJQKA]).\h\1")						? hand "`tOne Pair"
			: 									  hand "`tHigh Card"
}
CardSort(a, b){
	a := SubStr(a, 1, 1), b := SubStr(b, 1, 1)
	a := (a = "T") ? 10 : (a = "J") ? 11 : (a = "Q") ? 12 : (a = "K") ? 13 : a
	b := (b = "T") ? 10 : (b = "J") ? 11 : (b = "Q") ? 12 : (b = "K") ? 13 : b
	return a > b ? 1 : a < b ? -1 : 0
}

suits := ["♠", "♦", "♥", "♣"]
faces := [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
deck := [], p1 := [], p2 := []
for i, s in suits
	for j, v in faces
		deck.Push(v s)
deck := shuffle(deck)
deal := deal(deck, p1, p2)
p1 := deal.1, p2 := deal.2

for i, v in p2
{
	if InStr(v, "A")
		p2[i] := p1[i], p1[i] := v
	if InStr(v, "K")
		p2[i] := p1[i], p1[i] := v
	if InStr(v, "Q")
		p2[i] := p1[i], p1[i] := v
	if InStr(v, "J")
		p2[i] := p1[i], p1[i] := v
}
MsgBox % war(p1, p2)
return
war(p1, p2){
	J:=11, Q:=11, K:=11, A:=12, stack := [], cntr := 0
	output := "------------------------------------------"
			. "`nRound#  	  Deal	  		Winner	P1	P1"
			. "`n------------------------------------------"
			. "`nround0  			  				26	26"

	while (p1.Count() && p2.Count()) {
		cntr++
		stack.Push(c1:=p1.RemoveAt(1)), stack.Push(c2:=p2.RemoveAt(1))
		r1:=SubStr(c1,1,-1)	,r2:=SubStr(c2,1,-1)
		v1:=r1<11?r1:%r1%	,v2:=r2<11?r2:%r2%
		output .= "`nround# " cntr "`t" SubStr(c1 "  n", 1, 4) "vs " SubStr(c2 "  ", 1, 4)
		if (v1 > v2){
			loop % stack.Count()
				p1.Push(stack.RemoveAt(1))
			output .= "`t`tP1 wins"
		}
		else if (v1 < v2){
			loop % stack.Count()
				p2.Push(stack.RemoveAt(1))
			output .= "`t`tP2 wins"
		}
		if (v1 = v2){
			output .= "`t`t**WAR**`t" P1.Count() "`t" P2.Count()
			stack.Push(c1:=p1.RemoveAt(1)), stack.Push(c2:=p2.RemoveAt(1))
			if !(p1.Count() && p2.Count())
				break
			output .= "`nround# " ++cntr "`t(" SubStr(c1 "  ", 1, 3) ") - (" SubStr(c2 " ", 1, 3) ")"
			output .= "`tFace Dn"
		}
		output .= "`t" P1.Count() "`t" P2.Count()
		if !Mod(cntr, 20)
		{
			MsgBox % output
			output := ""
		}
	}
	output .= "`n" (P1.Count() ? "P1 Wins" : "P2 Wins")
	output := StrReplace(output, " )", ") ")
	output := StrReplace(output, "  -", " -")
	return output

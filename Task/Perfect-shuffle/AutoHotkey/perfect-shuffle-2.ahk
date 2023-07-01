test := [8, 24, 52, 100, 1020, 1024, 10000]
for each, val in test
{
	cards := [], original:=rep:=""
	loop, % val
		cards.push(A_Index), original .= (original?", ":"") A_Index
	while (res <> original)
	{
		res := ""
		for k, v in (cards := Shuffle(cards))
			res .= (res?", ":"") v
		rep := A_Index
	}
	result .= val "`t" rep "`n"
}
MsgBox % result
return

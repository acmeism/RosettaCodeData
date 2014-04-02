FreeCell(num){
	cards := "A23456789TJQK", suits := "♣♦♥♠", card := [], Counter := 0
	loop, parse, cards
	{
		ThisCard := A_LoopField
		loop, parse, suits
			Card[Counter++] := ThisCard . A_LoopField
	}
	loop, 52
	{
		a := MS(num)
		num:=a[1]
		MyCardNo := mod(a[2],53-A_Index)
		MyCard := Card[MyCardNo]
		Card[MyCardNo] := Card[52-A_Index]
		Card.Remove(52-A_Index)
		Res .= MyCard (Mod(A_Index,8)?"  ":"`n")	
	}
	return Res
}
MS(Seed) {
	Seed := Mod(214013 * Seed + 2531011, 2147483648)
	return, [Seed, Seed // 65536]
}

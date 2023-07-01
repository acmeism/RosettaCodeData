hands =
(join`r`n
2♥ 2♦ 2♣ k♣ q♦
2♥ 5♥ 7♦ 8♣ 9♠
a♥ 2♦ 3♣ 4♣ 5♦
2♥ 3♥ 2♦ 3♣ 3♦
2♥ 3♥ 2♦ 2♣ 3♦
2♥ 7♥ 2♦ 3♣ 3♦
2♥ 7♥ 7♦ 7♣ 7♠
T♥ j♥ q♥ a♥ K♥
T♥ j♥ q♥ 9♥ K♥
4♥ 4♠ k♠ 5♦ T♠
q♣ T♣ 7♣ 6♣ 4♣
)
loop, parse, hands, `n, `r
	res .= PokerHand(A_LoopField) "`n"
MsgBox, 262144, , % res
return

Shuffle(cards){
	n := cards.MaxIndex()/2,	res := []
	loop % n
		res.push(cards[A_Index]), res.push(cards[round(A_Index + n)])
	return res
}

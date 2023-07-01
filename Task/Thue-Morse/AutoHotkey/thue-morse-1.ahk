ThueMorse(num, iter){
	if !iter
		return num
	for i, n in StrSplit(num)
		opp .= !n
	res := ThueMorse(num . opp, --iter)
	return res
}

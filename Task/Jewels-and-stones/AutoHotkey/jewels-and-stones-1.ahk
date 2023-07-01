JewelsandStones(ss, jj){
	for each, jewel in StrSplit(jj)
		for each, stone in StrSplit(ss)
			if (stone == jewel)
				num++
	return num
}

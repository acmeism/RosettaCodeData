TwoSum(a, target){
	i := 1,	j := a.MaxIndex()
	while(i < j){
		if  (a[i] + a[j] = target)
			return i ", " j
		else if (a[i] + a[j] <  target)
			i++
		else if (a[i] + a[j] >  target)
			j--
	}
	return "not found"
}

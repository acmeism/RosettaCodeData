stoogesort = function(vect) {
	i = 1
	j = length(vect)
	if(vect[j] < vect[i])  vect[c(j, i)] = vect[c(i, j)]
	if(j - i > 1) {
		t = (j - i + 1) %/% 3
		vect[i:(j - t)] = stoogesort(vect[i:(j - t)])
		vect[(i + t):j] = stoogesort(vect[(i + t):j])
		vect[i:(j - t)] = stoogesort(vect[i:(j - t)])
	}
	vect
}

v = sample(21, 20)
k = stoogesort(v)
v
k

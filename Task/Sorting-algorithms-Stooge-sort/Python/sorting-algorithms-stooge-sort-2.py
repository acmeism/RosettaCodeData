>>> def stoogesort(L, i, j):
	if L[j] < L[i]:
		L[i], L[j] = L[j], L[i]
	if j - i > 1:
		t = (j - i + 1) // 3
		stoogesort(L, i  , j-t)
		stoogesort(L, i+t, j  )
		stoogesort(L, i  , j-t)
	return L

>>> def stooge(L): return stoogesort(L, 0, len(L) - 1)

>>> data = [1, 4, 5, 3, -6, 3, 7, 10, -2, -5, 7, 5, 9, -3, 7]
>>> stooge(data)
[-6, -5, -3, -2, 1, 3, 3, 4, 5, 5, 7, 7, 7, 9, 10]

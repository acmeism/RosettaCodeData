#!/usr/bin/awk -f

function levdist(str1, str2,	l1, l2, tog, arr, i, j, a, b, c) {
	if (str1 == str2) {
		return 0
	} else if (str1 == "" || str2 == "") {
		return length(str1 str2)
	} else if (substr(str1, 1, 1) == substr(str2, 1, 1)) {
		a = 2
		while (substr(str1, a, 1) == substr(str2, a, 1)) a++
		return levdist(substr(str1, a), substr(str2, a))
	} else if (substr(str1, l1=length(str1), 1) == substr(str2, l2=length(str2), 1)) {
		b = 1
		while (substr(str1, l1-b, 1) == substr(str2, l2-b, 1)) b++
		return levdist(substr(str1, 1, l1-b), substr(str2, 1, l2-b))
	}
	for (i = 0; i <= l2; i++) arr[0, i] = i
	for (i = 1; i <= l1; i++) {
		arr[tog = ! tog, 0] = i
		for (j = 1; j <= l2; j++) {
			a = arr[! tog, j  ] + 1
			b = arr[  tog, j-1] + 1
			c = arr[! tog, j-1] + (substr(str1, i, 1) != substr(str2, j, 1))
			arr[tog, j] = (((a<=b)&&(a<=c)) ? a : ((b<=a)&&(b<=c)) ? b : c)
		}
	}
	return arr[tog, j-1]
}

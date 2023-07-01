BEGIN {
	str = "abcdefghijklmnopqrstuvwxyz"
	n = 12
	m = 5

	print substr(str, n, m)
	print substr(str, n)
	print substr(str, 1, length(str) - 1)
	print substr(str, index(str, "q"), m)
	print substr(str, index(str, "pq"), m)
}

Data := [2,4,4,4,5,5,7,9]

for k, v in Data {
    FileAppend, % "#" a_index " value = " v " stddev = " stddev(v) "`n", * ; send to stdout
}
return

stddev(x) {
	static n, sum, sum2
	n++
	sum += x
	sum2 += x*x

	return sqrt((sum2/n) - (((sum*sum)/n)/n))
}

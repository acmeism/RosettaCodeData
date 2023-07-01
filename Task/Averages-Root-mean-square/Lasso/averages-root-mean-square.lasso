define rms(a::staticarray)::decimal => {
	return math_sqrt((with n in #a sum #n*#n) / decimal(#a->size))
}
rms(generateSeries(1,10)->asStaticArray)

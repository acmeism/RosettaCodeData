define arithmetic_mean(a::staticarray)::decimal => {
	//sum of the list divided by its length
	return (with e in #a sum #e) / decimal(#a->size)
}
define geometric_mean(a::staticarray)::decimal => {
	// The geometric mean is the nth root of the product of the list
	local(prod = 1)
	with e in #a do => { #prod *= #e }
	return math_pow(#prod,1/decimal(#a->size))
}
define harmonic_mean(a::staticarray)::decimal => {
	// The harmonic mean is n divided by the sum of the reciprocal of each item in the list
	return decimal(#a->size)/(with e in #a sum 1/decimal(#e))
}

arithmetic_mean(generateSeries(1,10)->asStaticArray)
geometric_mean(generateSeries(1,10)->asStaticArray)
harmonic_mean(generateSeries(1,10)->asStaticArray)

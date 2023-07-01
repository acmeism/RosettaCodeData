define map_range(
	a1,
	a2,
	b1,
	b2,
	number
) => (decimal(#b1) + (decimal(#number) - decimal(#a1)) * (decimal(#b2) - decimal(#b1)) / (decimal(#a2) - decimal(#a1))) -> asstring(-Precision = 1)

with number in generateSeries(1,10) do {^
	#number
	': '
	map_range( 0, 10, -1, 0, #number)
	'<br />'

^}'

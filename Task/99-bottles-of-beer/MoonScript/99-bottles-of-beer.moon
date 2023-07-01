p = (i) ->
	i != 1 and 's' or ''

for b = 99,1,-1
	for i = 1,4
		print if i == 3
			'Take one down, pass it around'
		else
			string.format '%s bottle%s of beer%s',
				i < 4 and b or b-1,
				i < 4 and (p b) or (p b-1),
				i%3 == 1 and ' on the wall' or ''
	io.write '\n'

concept largest(l) {
	large = l[0]
	for element in l
		if element > large
			large = element
		end
	end
	return large
}

software {
	print(largest([23, 1313, 21, 35757, 4, 434, 232, 2, 2342]))
}

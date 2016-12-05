define sumofsquares(values::array) => {

	local(sum = 0)

	with value in #values do {
		#sum += #value * #value
	}

	return #sum
}

sumofsquares(array(1,2,3,4,5))

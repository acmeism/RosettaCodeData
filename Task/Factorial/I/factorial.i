function fact(n, acc) r {
	if n = 0
		return acc
	end
	return fact(n-1, n*acc)
}

function factorial(n) r {
  return fact(n, 1)
}

software {
	print(factorial(0))
	print(factorial(1))
	print(factorial(2))
	print(factorial(3))
	print(factorial(22))
}

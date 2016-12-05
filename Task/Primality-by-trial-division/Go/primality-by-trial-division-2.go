func IsPrime(n int) bool {
	if n < 0 { n = -n }
	if n <= 2 {
		return n == 2
	}
	return n % 2 != 0 && isPrime_r(n, 3)
}

func isPrime_r(n, i int) bool {
	if i*i <= n {
		return n % i != 0 && isPrime_r(n, i+2)
	}
	return true
}

func IsPrime(n int) bool {
	if n < 0 { n = -n }
	switch {
        case n == 2:
		return true
	case n < 2 || n % 2 == 0:
		return false
	
	default:
		for i = 3; i*i <= n; i += 2 {
			if n % i == 0 { return false }
		}
	}
	return true
}

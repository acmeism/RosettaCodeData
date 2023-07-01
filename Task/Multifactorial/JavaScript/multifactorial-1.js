function multifact(n, deg){
	var result = n;
	while (n >= deg + 1){
		result *= (n - deg);
		n -= deg;
	}
	return result;
}

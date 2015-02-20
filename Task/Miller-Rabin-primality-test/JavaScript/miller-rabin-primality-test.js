function probablyPrime(n, k) {
	if (n === 2 || n === 3)
		return true;
	if (n % 2 === 0 || n < 2)
		return false;

	// Write (n - 1) as 2^s * d
	var s = 0, d = n - 1;
	while (d % 2 === 0) {
		d /= 2;
		++s;
	}

	WitnessLoop: do {
		// A base between 2 and n - 2
		var x = Math.pow(2 + Math.floor(Math.random() * (n - 3)), d) % n;

		if (x === 1 || x === n - 1)
			continue;

		for (var i = s - 1; i--;) {
			x = x * x % n;
			if (x === 1)
				return false;
			if (x === n - 1)
				continue WitnessLoop;
		}

		return false;
	} while (--k);

	return true;
}

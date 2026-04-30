	let product = 2n;
	function smallestPrimeFactor(number) {
	    if (number % 3n === 0n) { return 3n; }
	    if (number % 5n === 0n) { return 5n; }
	    for (let divisor = 7n; divisor * divisor <= number; divisor += 2n) {
	        if (number % divisor === 0n) { return divisor; }
	    }
	    return number;
	}
	function nextEuclidMullin() {
	    const smallestPrime = smallestPrimeFactor(product + 1n);
	    product *= smallestPrime;
	    return smallestPrime;
	}
	console.log("The first 9 terms of the Euclid-Mullin sequence:");
	process.stdout.write(2 + "  ");
	for (let i = 1; i < 9; ++i) {
	    process.stdout.write(nextEuclidMullin() + "  ");
	}
	console.log("\n");

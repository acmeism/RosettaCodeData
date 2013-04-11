function run_factorize(n) {
	if (n <= 3)
			return [n];

	var ans = [];
	var done = false;
	while (!done)
	{
		if (n%2 === 0){
				ans.push(2);
				n /= 2;
				continue;
		}
		if (n%3 === 0){
				ans.push(3);
				n /= 3;
				continue;
		}
		if ( n === 1)
			return ans;
		var sr = Math.sqrt(n);
		done = true;
		// try to divide the checked number by all numbers till its square root.
		for (var i=6; i<=sr; i+=6){
				if (n%(i-1) === 0){ // is n divisible by i-1?
						ans.push( (i-1) );
						n /= (i-1);
						done = false;
						break;
				}
				if (n%(i+1) === 0){ // is n divisible by i+1?
						ans.push( (i+1) );
						n /= (i+1);
						done = false;
						break;
				}
		}
	}
	ans.push( n );
	return ans;
}

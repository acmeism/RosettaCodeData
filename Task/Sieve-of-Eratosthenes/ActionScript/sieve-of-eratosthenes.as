function eratosthenes(limit:int):Array
{
	var primes:Array = new Array();
	if (limit >= 2) {
		var sqrtlmt:int = int(Math.sqrt(limit) - 2);
		var nums:Array = new Array(); // start with an empty Array...
		for (var i:int = 2; i <= limit; i++) // and
			nums.push(i); // only initialize the Array once...
		for (var j:int = 0; j <= sqrtlmt; j++) {
			var p:int = nums[j]
			if (p)
				for (var t:int = p * p - 2; t < nums.length; t += p)
					nums[t] = 0;
		}
		for (var m:int = 0; m < nums.length; m++) {
			var r:int = nums[m];
			if (r)
				primes.push(r);
		}
	}
	return primes;
}
var e:Array = eratosthenes(1000);
trace(e);

Primes := [2,43,81,122,63,13,7,95,103]

t := [], result := []
for i, n in Primes
	if isPrime(n)
		t[n, i] := true
	
for n, obj in t
    for i, v in obj
        result.push(n)
	
isPrime(n){
	Loop, % floor(sqrt(n))
		v := A_Index = 1 ? n : mod(n,A_Index) ? v : v "," A_Index "," n//A_Index
	Return (v = n)
}

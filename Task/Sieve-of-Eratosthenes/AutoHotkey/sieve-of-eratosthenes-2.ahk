Sieve_of_Eratosthenes(n){
	arr := []
	loop % n-1
		if A_Index>1
			arr[A_Index] := true

	for i, v in arr	{
		if (i>Sqrt(n))
			break
		else if arr[i]
			while ((j := i*2 + (A_Index-1)*i) < n)
				arr.delete(j)
	}
	return Arr
}

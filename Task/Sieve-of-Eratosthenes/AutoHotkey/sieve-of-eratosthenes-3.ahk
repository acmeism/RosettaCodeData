n := 101
Arr := Sieve_of_Eratosthenes(n)
loop, % n-1
	output .= (Arr[A_Index] ? A_Index : ".") . (!Mod(A_Index, 10) ? "`n" : "`t")
MsgBox % output
return

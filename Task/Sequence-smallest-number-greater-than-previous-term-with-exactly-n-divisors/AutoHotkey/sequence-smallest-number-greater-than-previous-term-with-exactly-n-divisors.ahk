MAX := 15
next := 1, i := 1
while (next <= MAX)
	if (next = countDivisors(A_Index))
		Res.= A_Index ", ", next++
MsgBox % "The first " MAX " terms of the sequence are:`n" Trim(res, ", ")
return

countDivisors(n){
	while (A_Index**2 <= n)
		if !Mod(n, A_Index)
			count += (A_Index = n/A_Index) ? 1 : 2
	return count
}

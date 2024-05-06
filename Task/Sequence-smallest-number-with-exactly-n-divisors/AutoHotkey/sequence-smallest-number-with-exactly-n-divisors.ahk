max := 15
seq := [], n := 0
while (n < max)
	if ((k := countDivisors(A_Index)) <= max) && !seq[k]
		seq[k] := A_Index, n++
for i, v in seq
	res .= v ", "
MsgBox % "The first " . max . " terms of the sequence are:`n" Trim(res, ", ")
return

countDivisors(n){
	while (A_Index**2 <= n)
		if !Mod(n, A_Index)
			count += A_Index = n/A_Index ? 1 : 2
	return count
}

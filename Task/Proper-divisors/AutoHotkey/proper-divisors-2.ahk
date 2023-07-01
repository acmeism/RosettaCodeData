output := "Number`tDivisors`tCount`n"
loop, 10
{
	output .= A_Index "`t"
	for n, bool in x := proper_divisors(A_Index)
		output .= n " "
	output .= "`t" x.count() "`n"
}
maxDiv := 0, numDiv := []
loop, 20000
{
	Arr := proper_divisors(A_Index)
	numDiv[Arr.count()] := (numDiv[Arr.count()] ? numDiv[Arr.count()] ", " : "") A_Index
	maxDiv := maxDiv > Arr.count() ? maxDiv : Arr.count()
}
output .= "`nNumber(s) in the range 1 to 20,000 with the most proper divisors:`n" numDiv.Pop() " with " maxDiv " divisors"
MsgBox % output
return

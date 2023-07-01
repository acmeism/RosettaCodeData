output := "First 25 abundant odd numbers:`n"
while (count<1000)
{
	oddNum := 2*A_Index-1
	if (str := Abundant(oddNum))
	{
		count++
		if (count<=25)
			output .= oddNum " " str "`n"
		if (count = 1000)
			output .= "`nOne thousandth abundant odd number:`n" oddNum " " str "`n"
	}
}
count := 0
while !count
{
	num := 2*A_Index -1 + 1000000000
	if (str := Abundant(num))
	{
		count++
		output .= "`nFirst abundant odd number greater than one billion:`n" num " " str "`n"
	}
}
MsgBox % output
return

Loop, 30
	Out1 .= PopCount(3 ** (A_Index - 1)) " "
Loop, 60
	i := A_Index - 1
	, PopCount(i) & 0x1 ? Out3 .= i " " : Out2 .= i " "
MsgBox, % "3^x:`t" Out1 "`nEvil:`t" Out2 "`nOdious:`t" Out3

PopCount(x) {	;https://en.wikipedia.org/wiki/Hamming_weight#Efficient_implementation
	x -= (x >> 1) & 0x5555555555555555
	, x := (x & 0x3333333333333333) + ((x >> 2) & 0x3333333333333333)
	, x := (x + (x >> 4)) & 0x0f0f0f0f0f0f0f0f
	return (x * 0x0101010101010101) >> 56
}

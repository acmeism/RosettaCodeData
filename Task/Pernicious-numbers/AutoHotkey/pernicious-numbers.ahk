c := 0
while c < 25
	if IsPern(A_Index)
		Out1 .= A_Index " ", c++
Loop, 12
	if IsPern(n := 888888876 + A_Index)
		Out2 .= n " "
MsgBox, % Out1 "`n" Out2

IsPern(x) {	;https://en.wikipedia.org/wiki/Hamming_weight#Efficient_implementation
	static p := {2:1, 3:1, 5:1, 7:1, 11:1, 13:1, 17:1, 19:1, 23:1, 29:1, 31:1, 37:1, 41:1, 43:1, 47:1, 53:1, 59:1, 61:1}
	x -= (x >> 1) & 0x5555555555555555
	, x := (x & 0x3333333333333333) + ((x >> 2) & 0x3333333333333333)
	, x := (x + (x >> 4)) & 0x0f0f0f0f0f0f0f0f
	return p[(x * 0x0101010101010101) >> 56]
}

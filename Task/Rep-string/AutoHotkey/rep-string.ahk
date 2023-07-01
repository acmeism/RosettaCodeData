In := ["1001110011", "1110111011", "0010010010", "1010101010"
     , "1111111111", "0100101101", "0100100", "101", "11", "00", "1"]
for k, v in In
	Out .= RepString(v) "`t" v "`n"
MsgBox, % Out

RepString(s) {
	Loop, % StrLen(s) // 2 {
		i := A_Index
		Loop, Parse, s
		{
			pos := Mod(A_Index, i)
			if (A_LoopField != SubStr(s, !pos ? i : pos, 1))
				continue, 2
		}
		return SubStr(s, 1, i)
	}
	return "N/A"
}

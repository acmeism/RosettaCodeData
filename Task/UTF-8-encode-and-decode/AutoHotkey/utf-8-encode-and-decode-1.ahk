Encode_UTF(hex){
	Bytes :=  hex>=0x10000 ? 4 : hex>=0x0800 ? 3 : hex>=0x0080 ? 2 : hex>=0x0001 ? 1 : 0
	Prefix := [0, 0xC0, 0xE0, 0xF0]
	loop % Bytes {
		if (A_Index < Bytes)
			UTFCode := Format("{:X}", (hex&0x3F) + 0x80) . UTFCode		; 3F=00111111, 80=10000000
		else
			UTFCode := Format("{:X}", hex + Prefix[Bytes]) . UTFCode	; C0=11000000, E0=11100000, F0=11110000
		hex := hex>>6
	}
	return "0x" UTFCode
}
;----------------------------------------------------------------------------------------
Decode_UTF(hex){
	Bytes :=  hex>=0x10000 ? 4 : hex>=0x0800 ? 3 : hex>=0x0080 ? 2 : hex>=0x0001 ? 1 : 0
	bin := ConvertBase(16, 2, hex)
	loop, % Bytes {
		B := SubStr(bin, -7)
		if Bytes > 1
			B := LTrim(B, 1) , B := StrReplace(B, 0,,, 1)
		bin := SubStr(bin, 1, StrLen(bin)-8)
		Uni := B . Uni
	}
	return "0x" ConvertBase(2, 16, Uni)
}
;----------------------------------------------------------------------------------------
; www.autohotkey.com/boards/viewtopic.php?f=6&t=3607#p18985
ConvertBase(InputBase, OutputBase, number){
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    VarSetCapacity(s, 65, 0)
    value := DllCall("msvcrt.dll\" u, "Str", number, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}

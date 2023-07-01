ParseIP(Address){
	return InStr(A_LoopField, ".") ? IPv4(Address) : IPv6(Address)
}

IPv4(Address){
	for i, v in StrSplit(Address, "."){
		x := StrSplit(v, ":")
		num .= SubStr("00" . Format("{:X}", x.1), -1)
		port := x.2 ? x.2 : ""
	}
	return [num, port]
}

IPv6(Address){
	for i, v in StrSplit(Address, "]")
		if i = 1
			for j, x in StrSplit(LTrim(v, "[:"), ":")
				num .= x = "" ? "00000000" : SubStr("0000" x, -3)
		else
			port := LTrim(v, ":")
	return [SubStr("00000000000000000000000000000000" num, -31), port]
}

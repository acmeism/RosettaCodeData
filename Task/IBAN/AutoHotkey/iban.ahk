IBANs := ["GB82 WEST 1234 5698 7654 32"
	, "gb82 WEST 1234 5698 7654 32"
	, "GB82WEST12345698765432"
	, "GB82 WEST 234 5698 7654 32"
	, "GB82 WEST 1234 5698 7654 33"
	, "AE82 WEST 1234 5698 7654 32"]
for k, v in IBANs
	Output .= v " is" (ValidIBAN(v) ? "" : " not") " valid.`n"
MsgBox, % Output

ValidIBAN(n) {
	static CC := {AL:28, AD:24, AT:20, AZ:28, BH:22, BE:16, BA:20, BR:29, BG:22, CR:21
		    , HR:21, CY:28, CZ:24, DK:18, DO:28, EE:20, FO:18, FI:18, FR:27, GE:22
		    , DE:22, GI:23, GR:27, GL:18, GT:28, HU:28, IS:26, IE:22, IL:23, IT:27
		    , JO:30, KZ:20, KW:30, LV:21, LB:28, LI:21, LT:20, LU:20, MK:19, MT:31
		    , MR:27, MU:30, MC:27, MD:24, ME:22, NL:18, NO:15, PK:24, PS:29, PL:28
		    , PT:25, QA:29, RO:24, SM:27, SA:24, RS:22, SK:24, SI:19, ES:24, SE:24
		    , CH:21, TN:24, TR:26, AE:23, GB:22, VG:24}
	StringReplace, n, n, % A_Space,, A
	;Check that the total IBAN length is correct as per the country
	if (StrLen(n) != CC[SubStr(n, 1, 2)])
		return false
	StringUpper, n, n
	;Move the four initial characters to the end of the string
	n := SubStr(n, 5) SubStr(n, 1, 4)
	;Replace each letter in the string with two digits
	Loop, Parse, n
	{
		if A_LoopField is alpha
			nn .= Asc(A_LoopField) - 55
		else
			nn .= A_LoopField
	}
	return Mod97(nn) = 1
}

Mod97(a) {
	while a {
		rem := Mod(rem SubStr(a, 1, 15), 97)
		a := SubStr(a, 16)
	}
	return rem
}

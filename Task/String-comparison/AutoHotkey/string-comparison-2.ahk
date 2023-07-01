for a, b in {"alpha":"beta", "Gamma":"gamma", 100:5}
	MsgBox % a " vs " b "`n"
	. "exact_equality case sensitive : " exact_equality(a,b) "`n"
	. "exact_inequality case sensitive :" exact_inequality(a,b) "`n"
	. "equality case insensitive : " equality(a,b) "`n"
	. "inequality case insensitive : " inequality(a,b) "`n"
	. "ordered_before : " ordered_before(a,b) "`n"
	. "ordered_after : " ordered_after(a,b) "`n"

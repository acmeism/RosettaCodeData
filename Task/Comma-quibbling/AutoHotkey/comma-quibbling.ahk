MsgBox % quibble([])
MsgBox % quibble(["ABC"])
MsgBox % quibble(["ABC", "DEF"])
MsgBox % quibble(["ABC", "DEF", "G", "H"])

quibble(d) {
	s:=""
	for i, e in d
	{
		if (i<d.MaxIndex()-1)
			s:= s . e . ", "
		else if (i=d.MaxIndex()-1)
			s:= s . e . " and "
		else
			s:= s . e
	}
	return "{" . s . "}"
}

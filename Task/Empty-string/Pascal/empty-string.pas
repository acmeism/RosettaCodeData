program emptyString(output);
var
	s: string(20);
begin
	{ assigning an empty string }
	s := '';
	
	{ checking for an empty string }
	writeLn(   'EQ(s, '''') :':20, EQ(s, ''):6);
	writeLn( 'length(s) = 0 :':20, length(s) = 0:6);
	
	{ checking that a string is not empty }
	writeLn(   'NE(s, '''') :':20, NE(s, ''):6);
	writeLn( 'length(s) > 0 :':20, length(s) > 0:6);
	
	{ Beware: Only the string comparison functions (`EQ`, `NE`, etc.) take }
	{ the string’s length into account. The symbolic `=` equal comparison }
	{ operator, however, will pad operands with blanks to the same common }
	{ length, and _subsequently_ compare individual string components. }
	writeLn('!!!  s = '' '' :':20, s = ' ':6);
	{ If you want to perform the empty string check with an `=` comparison, }
	{ you will need to call `trim` (remove trailing blanks) first. }
	writeLn('trim(s) = '''' :':20, trim(s) = '':6)
end.

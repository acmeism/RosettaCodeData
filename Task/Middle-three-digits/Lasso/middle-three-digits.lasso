define middlethree(value::integer) => {
	local(
		pos_value	= math_abs(#value),
		stringvalue	= #pos_value -> asstring,
		intlength	= #stringvalue -> size,
		middle		= integer((#intlength + 1) / 2),
		prefix		= string(#value) -> padleading(15)& + ': '
	)

	#intlength < 3 ? return #prefix + 'Error: too few digits'
	not(#intlength % 2) ? return #prefix + 'Error: even number of digits'

	return #prefix + #stringvalue -> sub(#middle -1, 3)

}
'<pre>'
with number in array(123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0) do {^

	middlethree(#number)
	'<br />'
^}
'</pre>'

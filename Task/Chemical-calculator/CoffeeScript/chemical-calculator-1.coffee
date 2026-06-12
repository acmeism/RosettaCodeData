ATOMIC_MASS = {H:1.008,C:12.011,O:15.999,Na:22.98976928,S:32.06,Uue:315}

molar_mass = (s) ->
	result = ''
	i = 0
	member = (a,c) ->  a <= s[i] <= c
	next = ->
		i += 1
		s[i-1]
	while i < s.length
		if s[i] == '(' then result += '+' + next()
		else if s[i] == ')' then result += next()
		else if member '0','9'
			result += '*'
			result += next() while member '0','9'
		else if member 'A','Z'
			name = next()
			name += next() while member 'a','z'
			result += '+' + ATOMIC_MASS[name]
	parseFloat eval(result).toFixed 3

assert 1.008, molar_mass 'H'
assert 2.016, molar_mass 'H2'
assert 18.015, molar_mass 'H2O'
assert 34.014, molar_mass 'H2O2'
assert 34.014, molar_mass '(HO)2'
assert 142.036, molar_mass 'Na2SO4'
assert 84.162, molar_mass 'C6H12'
assert 186.295, molar_mass 'COOH(C(CH3)2)3CH3'
assert 176.124, molar_mass 'C6H4O2(OH)4' # Vitamin C
assert 386.664, molar_mass 'C27H46O' # Cholesterol
assert 315, molar_mass 'Uue'

ATOMIC_MASS = {H:1.008,C:12.011,O:15.999,Na:22.98976928,S:32.06,Uue:315}

mul = (match, p1, offset, string) -> '*' + p1
add = (match, p1, offset, string) ->
	if p1 == '(' then return '+' + p1
	"+#{ATOMIC_MASS[p1]}"

molar_mass = (s) ->
	s = s.replace /(\d+)/g, mul
	s = s.replace /([A-Z][a-z]{0,2}|\()/g, add
	parseFloat(eval(s).toFixed(3))

assert 1.008, molar_mass('H')
assert 2.016, molar_mass('H2')
assert 18.015, molar_mass('H2O')
assert 34.014, molar_mass('H2O2')
assert 34.014, molar_mass('(HO)2')
assert 142.036, molar_mass('Na2SO4')
assert 84.162, molar_mass('C6H12')
assert 186.295, molar_mass('COOH(C(CH3)2)3CH3')
assert 176.124, molar_mass('C6H4O2(OH)4') # Vitamin C
assert 386.664, molar_mass('C27H46O') # Cholesterol
assert 315, molar_mass('Uue')

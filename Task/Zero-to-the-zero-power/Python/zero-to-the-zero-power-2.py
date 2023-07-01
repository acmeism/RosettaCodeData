from decimal import Decimal
from fractions import Fraction
for n in (Decimal(0), Fraction(0, 1), complex(0), float(0), int(0)):
	try:
		n1 = n**n
	except:
		n1 = '<Raised exception>'
	try:
		n2 = pow(n, n)
	except:
		n2 = '<Raised exception>'
	print('%8s: ** -> %r; pow -> %r' % (n.__class__.__name__, n1, n2))

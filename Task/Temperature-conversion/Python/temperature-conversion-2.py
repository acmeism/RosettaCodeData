>>> toK = {'C': (lambda c: c + 273.15),
           'F': (lambda f: (f + 459.67) / 1.8),
           'R': (lambda r: r / 1.8),
           'K': (lambda k: k) }
>>> while True:
	magnitude, unit = input('<value> <K/R/F/C> ? ').split()
	k = toK[unit](float(magnitude))
	print("%g Kelvin = %g Celsius = %g Fahrenheit = %g Rankine degrees."
	      % (k, k - 273.15, k * 1.8 - 459.67, k * 1.8))

	
<value> <K/R/F/C> ? 222.2 K
222.2 Kelvin = -50.95 Celsius = -59.71 Fahrenheit = 399.96 Rankine degrees.
<value> <K/R/F/C> ? -50.95 C
222.2 Kelvin = -50.95 Celsius = -59.71 Fahrenheit = 399.96 Rankine degrees.
<value> <K/R/F/C> ? -59.71 F
222.2 Kelvin = -50.95 Celsius = -59.71 Fahrenheit = 399.96 Rankine degrees.
<value> <K/R/F/C> ? 399.96 R
222.2 Kelvin = -50.95 Celsius = -59.71 Fahrenheit = 399.96 Rankine degrees.
<value> <K/R/F/C> ?

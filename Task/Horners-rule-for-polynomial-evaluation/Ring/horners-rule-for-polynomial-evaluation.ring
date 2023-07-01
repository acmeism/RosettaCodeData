coefficients = [-19, 7, -4, 6]
see "x =  3" + nl +
"degree =  3" + nl +
"equation =  6*x^3-4*x^2+7*x-19" + nl +
"result = " + horner(coefficients, 3) + nl

func horner coeffs, x
w = 0
for n = len(coeffs) to 1 step -1
    w = w * x + coeffs[n]
next
return w

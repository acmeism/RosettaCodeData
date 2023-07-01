from fractions import Fraction

def rump(generic_a, generic_b) -> float:
    a = Fraction('{}'.format(generic_a))
    b = Fraction('{}'.format(generic_b))
    fractional_result = Fraction('333.75') * b**6 \
        + a**2 * ( 11 * a**2 * b**2 - b**6 - 121 * b**4 - 2 ) \
        + Fraction('5.5') * b**8 + a / (2 * b)
    return(float(fractional_result))

print("rump(77617, 33096) = ", rump(77617.0, 33096.0))

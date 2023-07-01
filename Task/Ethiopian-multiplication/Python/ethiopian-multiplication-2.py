halve  = lambda x: x // 2
double = lambda x: x*2
even   = lambda x: not x % 2

def ethiopian(multiplier, multiplicand):
    result = 0

    while multiplier >= 1:
        if not even(multiplier):
            result += multiplicand
        multiplier   = halve(multiplier)
        multiplicand = double(multiplicand)

    return result

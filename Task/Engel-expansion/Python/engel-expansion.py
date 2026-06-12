from math import ceil,gcd,floor

class Rational:
    def __init__(this, numerator, denominator = 1):
        if (type(numerator)==str):
            # Handle decimal string input
            decimalIndex = numerator.find('.')
            if (decimalIndex == -1):
                this.numerator = int(numerator)
                this.denominator = int(1)
            else:
                decimalPlaces = len(numerator) - 1 - decimalIndex
                numer = int(numerator.replace('.', ''))
                denom = int(10) ** int(decimalPlaces)
                gcdValue = gcd(numer, denom)
                this.numerator = numer / gcdValue
                this.denominator = denom / gcdValue
        else:
            this.numerator = int(numerator)
            this.denominator = int(denominator)
            if (this.denominator == 0):
                raise Exception("Denominator cannot be zero")
            gcdValue = gcd(this.numerator, this.denominator)
            this.numerator /= gcdValue
            this.denominator /= gcdValue

    def toDecimal(this, decimalPlaces = 10):
        result = ''
        numer = int(this.numerator)
        denom = int(this.denominator)
        quotient = numer // denom
        for i in range(decimalPlaces+1):
            result += str(quotient)
            numer -= denom * quotient
            if (numer == 0):
                break
            numer *= 10
            quotient = numer // denom
            if (i == 0):
                result += '.'
        return result

    def __eq__(this, other):
        return this.numerator == other.numerator and this.denominator == other.denominator

    def __add__(this, other):
        numer = (this.numerator * other.denominator) + (this.denominator * other.numerator)
        denom = this.denominator * other.denominator
        return Rational(numer, denom)

    def __sub__(this, other):
        numer = (this.numerator * other.denominator) - (this.denominator * other.numerator)
        denom = this.denominator * other.denominator
        return Rational(numer, denom)

    def __mul__(this,other):
        return Rational(this.numerator * other.numerator, this.denominator * other.denominator)

    def inverse(this):
        return Rational(this.denominator, this.numerator)

    def __ceil__(this):
        if (this.numerator % this.denominator == 0):
            return this.numerator / this.denominator
        return this.numerator / this.denominator + 1

RATIONAL_ZERO = Rational(0, 1)
RATIONAL_ONE = Rational(1, 1)

def toEngel(decimal):
    engel = []
    rational = Rational(decimal)

    while not (rational == RATIONAL_ZERO):
        term = ceil(rational.inverse())
        engel += [int(term)]
        rational *= Rational(term)
        rational -= RATIONAL_ONE
    return engel

def fromEngel(engel):
    sum = RATIONAL_ZERO
    product = RATIONAL_ONE

    for element in engel:
        rational = Rational(element).inverse()
        product *= rational
        sum += product
    return sum

def main():
    rationals = ["3.14159265358979", "2.71828182845904", "1.414213562373095"]

    for rational in rationals:
        engel = toEngel(rational)
        print(f"Rational number : {rational}")
        print(f"Engel expansion : {' '.join(str(x) for x in engel)}")
        print(f"Number of terms : {len(engel)}")

        # Due to precision limits, we'll use a reduced set of terms
        decimalPlaces = len(rational) - rational.find('.') - 1
        reducedEngel = engel[:9]
        print(f"Back to rational: {fromEngel(reducedEngel).toDecimal(floor(decimalPlaces / 2))}");
        print()

# Run the main function
main()

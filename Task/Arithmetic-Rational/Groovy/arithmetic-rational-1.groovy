class Rational implements Comparable {
    final BigInteger numerator, denominator

    static final Rational ONE = new Rational(1, 1)

    static final Rational ZERO = new Rational(0, 1)

    Rational(BigInteger whole) { this(whole, 1) }

    Rational(BigDecimal decimal) {
        this(
            decimal.scale() < 0 ? decimal.unscaledValue()*10**(-decimal.scale()) : decimal.unscaledValue(),
            decimal.scale() < 0 ? 1 : 10**(decimal.scale())
        )
    }

    Rational(num, denom) {
        assert denom != 0 : "Denominator must not be 0"
        def values = denom > 0 ? [num, denom] : [-num, -denom] //reduce(num, denom)

        numerator = values[0]
        denominator = values[1]
    }

    private List reduce(BigInteger num, BigInteger denom) {
        BigInteger sign = ((num < 0) != (denom < 0)) ? -1 : 1
        num = num.abs()
        denom = denom.abs()
        BigInteger commonFactor = gcd(num, denom)

        [num.intdiv(commonFactor) * sign, denom.intdiv(commonFactor)]
    }

    public Rational toLeastTerms() {
        def reduced = reduce(numerator, denominator)
        new Rational(reduced[0], reduced[1])
    }

    private BigInteger gcd(BigInteger n, BigInteger m) { n == 0 ? m : { while(m%n != 0) { def t=n; n=m%n; m=t }; n }() }

    Rational plus (Rational r) { new Rational(numerator*r.denominator + r.numerator*denominator, denominator*r.denominator) }

    Rational plus (BigInteger n) { new Rational(numerator + n*denominator, denominator) }

    Rational next () { new Rational(numerator + denominator, denominator) }

    Rational minus (Rational r) { new Rational(numerator*r.denominator - r.numerator*denominator, denominator*r.denominator) }

    Rational minus (BigInteger n) { new Rational(numerator - n*denominator, denominator) }

    Rational previous () { new Rational(numerator - denominator, denominator) }

    Rational multiply (Rational r) { new Rational(numerator*r.numerator, denominator*r.denominator) }

    Rational multiply (BigInteger n) { new Rational(numerator*n, denominator) }

    Rational div (Rational r) { new Rational(numerator*r.denominator, denominator*r.numerator) }

    Rational div (BigInteger n) { new Rational(numerator, denominator*n) }

    BigInteger intdiv (BigInteger n) { numerator.intdiv(denominator*n) }

    Rational negative () { new Rational(-numerator, denominator) }

    Rational abs () { new Rational(numerator.abs(), denominator) }

    Rational reciprocal() { new Rational(denominator, numerator) }

    Rational power(BigInteger n) { new Rational(numerator ** n, denominator ** n) }

    boolean asBoolean() { numerator != 0 }

    BigDecimal toBigDecimal() { (numerator as BigDecimal)/(denominator as BigDecimal) }

    BigInteger toBigInteger() { numerator.intdiv(denominator) }

    Double toDouble() { toBigDecimal().toDouble() }

    double doubleValue() { toDouble() as double }

    Float toFloat() { toBigDecimal().toFloat() }

    float floatValue() { toFloat() as float }

    Integer toInteger() { toBigInteger().toInteger() }

    int intValue() { toInteger() as int }

    Long toLong() { toBigInteger().toLong() }

    long longValue() { toLong() as long }

    Object asType(Class type) {
        switch (type) {
            case this.getClass():     return this
            case Boolean.class:       return asBoolean()
            case BigDecimal.class:    return toBigDecimal()
            case BigInteger.class:    return toBigInteger()
            case Double.class:        return toDouble()
            case Float.class:         return toFloat()
            case Integer.class:       return toInteger()
            case Long.class:          return toLong()
            case String.class:        return toString()
            default:                  throw new ClassCastException("Cannot convert from type Rational to type " + type)
        }
    }

    boolean equals(o) {
        compareTo(o) == 0
    }

    int compareTo(o) {
        o instanceof Rational \
            ? compareTo(o as Rational) \
            : o instanceof Number \
                ? compareTo(o as Number)\
                : (Double.NaN as int)
    }

    int compareTo(Rational r) { numerator*r.denominator <=> denominator*r.numerator }

    int compareTo(Number n) { numerator <=> denominator*(n as BigInteger) }

    int hashCode() { [numerator, denominator].hashCode() }

    String toString() {
        def reduced = reduce(numerator, denominator)
        "${reduced[0]}//${reduced[1]}"
    }
}

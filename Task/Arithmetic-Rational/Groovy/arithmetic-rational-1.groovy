class Rational extends Number implements Comparable {
    final BigInteger num, denom

    static final Rational ONE = new Rational(1)
    static final Rational ZERO = new Rational(0)

    Rational(BigDecimal decimal) {
        this(
        decimal.scale() < 0 ? decimal.unscaledValue() * 10 ** -decimal.scale() : decimal.unscaledValue(),
        decimal.scale() < 0 ? 1                                                : 10 ** decimal.scale()
        )
    }

    Rational(BigInteger n, BigInteger d = 1) {
        if (!d || n == null) { n/d }
        (num, denom) = reduce(n, d)
    }

    private List reduce(BigInteger n, BigInteger d) {
        BigInteger sign = ((n < 0) ^ (d < 0)) ? -1 : 1
        (n, d) = [n.abs(), d.abs()]
        BigInteger commonFactor = gcd(n, d)

        [n.intdiv(commonFactor) * sign, d.intdiv(commonFactor)]
    }

    Rational toLeastTerms() { reduce(num, denom) as Rational }

    private BigInteger gcd(BigInteger n, BigInteger m) {
        n == 0 ? m : { while(m%n != 0) { (n, m) = [m%n, n] }; n }()
    }

    Rational plus(Rational r) { [num*r.denom + r.num*denom, denom*r.denom] }
    Rational plus(BigInteger n) { [num + n*denom, denom] }
    Rational plus(Number n) { this + ([n] as Rational) }

    Rational next() { [num + denom, denom] }

    Rational minus(Rational r) { [num*r.denom - r.num*denom, denom*r.denom] }
    Rational minus(BigInteger n) { [num - n*denom, denom] }
    Rational minus(Number n) { this - ([n] as Rational) }

    Rational previous() { [num - denom, denom] }

    Rational multiply(Rational r) { [num*r.num, denom*r.denom] }
    Rational multiply(BigInteger n) { [num*n, denom] }
    Rational multiply(Number n) { this * ([n] as Rational) }


    Rational div(Rational r) { new Rational(num*r.denom, denom*r.num) }
    Rational div(BigInteger n) { new Rational(num, denom*n) }
    Rational div(Number n) { this / ([n] as Rational) }

    BigInteger intdiv(BigInteger n) { num.intdiv(denom*n) }

    Rational negative() { [-num, denom] }

    Rational abs() { [num.abs(), denom] }

    Rational reciprocal() { new Rational(denom, num) }

    Rational power(BigInteger n) {
        def (nu, de) = (n < 0 ? [denom, num] : [num, denom])*.power(n.abs())
        new Rational (nu, de)
    }

    boolean asBoolean() { num != 0 }

    BigDecimal toBigDecimal() { (num as BigDecimal)/(denom as BigDecimal) }

    BigInteger toBigInteger() { num.intdiv(denom) }

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
            case this.class:              return this
            case [Boolean, Boolean.TYPE]: return asBoolean()
            case BigDecimal:              return toBigDecimal()
            case BigInteger:              return toBigInteger()
            case [Double, Double.TYPE]:   return toDouble()
            case [Float, Float.TYPE]:     return toFloat()
            case [Integer, Integer.TYPE]: return toInteger()
            case [Long, Long.TYPE]:       return toLong()
            case String:                  return toString()
            default: throw new ClassCastException("Cannot convert from type Rational to type " + type)
        }
    }

    boolean equals(o) { compareTo(o) == 0 }

    int compareTo(o) {
        o instanceof Rational
            ? compareTo(o as Rational)
            : o instanceof Number
                ? compareTo(o as Number)
                : (Double.NaN as int)
    }
    int compareTo(Rational r) { num*r.denom <=> denom*r.num }
    int compareTo(Number n) { num <=> denom*(n as BigInteger) }

    int hashCode() { [num, denom].hashCode() }

    String toString() {
        "${num}//${denom}"
    }
}

enum T {
    m('-', -1), z('0', 0), p('+', 1)

    final String symbol
    final int value

    private T(String symbol, int value) {
        this.symbol = symbol
        this.value = value
    }

    static T get(Object key) {
        switch (key) {
            case [m.value, m.symbol] : return m
            case [z.value, z.symbol] : return z
            case [p.value, p.symbol] : return p
            default:                   return null
        }
    }

    T negative() {
        T.get(-this.value)
    }

    String toString() { this.symbol }
}


class BalancedTernaryInteger {

    static final MINUS = new BalancedTernaryInteger(T.m)
    static final ZERO  = new BalancedTernaryInteger(T.z)
    static final PLUS  = new BalancedTernaryInteger(T.p)
    private static final LEADING_ZEROES = /^0+/

    final String value

    BalancedTernaryInteger(String bt) {
        assert bt && bt.toSet().every { T.get(it) }
        value = bt ==~ LEADING_ZEROES ? T.z : bt.replaceAll(LEADING_ZEROES, '');
    }

    BalancedTernaryInteger(BigInteger i) {
        this(i == 0 ? T.z.symbol : valueFromInt(i));
    }

    BalancedTernaryInteger(T...tArray) {
        this(tArray.sum{ it.symbol });
    }

    BalancedTernaryInteger(List<T> tList) {
        this(tList.sum{ it.symbol });
    }

    private static String valueFromInt(BigInteger i) {
        assert i != null
        if (i < 0) return negate(valueFromInt(-i))
        if (i == 0) return ''
        int bRem = (((i % 3) - 2) ?: -3) + 2
        valueFromInt((i - bRem).intdiv(3)) + T.get(bRem)
    }

    private static String negate(String bt) {
        bt.collect{ T.get(it) }.inject('') { str, t ->
            str + (-t)
        }
    }

    private static final Map INITIAL_SUM_PARTS = [carry:T.z, sum:[]]
    private static final prepValueLen = { int len, String s ->
        s.padLeft(len + 1, T.z.symbol).collect{ T.get(it) }
    }
    private static final partCarrySum = { partialSum, carry, trit ->
        [carry: carry, sum: [trit] + partialSum]
    }
    private static final partSum = { parts, trits ->
        def carrySum = partCarrySum.curry(parts.sum)
        switch ((trits + parts.carry).sort()) {
            case [[T.m, T.m, T.m]]:                  return carrySum(T.m, T.z) //-3
            case [[T.m, T.m, T.z]]:                  return carrySum(T.m, T.p) //-2
            case [[T.m, T.z, T.z], [T.m, T.m, T.p]]: return carrySum(T.z, T.m) //-1
            case [[T.z, T.z, T.z], [T.m, T.z, T.p]]: return carrySum(T.z, T.z) //+0
            case [[T.z, T.z, T.p], [T.m, T.p, T.p]]: return carrySum(T.z, T.p) //+1
            case [[T.z, T.p, T.p]]:                  return carrySum(T.p, T.m) //+2
            case [[T.p, T.p, T.p]]: default:         return carrySum(T.p, T.z) //+3
        }
    }

    BalancedTernaryInteger plus(BalancedTernaryInteger that) {
        assert that != null
        if (this == ZERO) return that
        if (that == ZERO) return this
        def prep = prepValueLen.curry([value.size(), that.value.size()].max())
        List values = [prep(value), prep(that.value)].transpose()
        new BalancedTernaryInteger(values[-1..(-values.size())].inject(INITIAL_SUM_PARTS, partSum).sum)
    }

    BalancedTernaryInteger negative() {
        !this ? this : new BalancedTernaryInteger(negate(value))
    }

    BalancedTernaryInteger minus(BalancedTernaryInteger that) {
        assert that != null
        this + -that
    }

    private static final INITIAL_PRODUCT_PARTS = [sum:ZERO, pad:'']
    private static final sigTritCount = { it.value.replaceAll(T.z.symbol,'').size() }

    private BalancedTernaryInteger paddedValue(String pad) {
        new BalancedTernaryInteger(value + pad)
    }

    private BalancedTernaryInteger partialProduct(T multiplier, String pad){
        switch (multiplier) {
            case T.z:          return ZERO
            case T.m:          return -paddedValue(pad)
            case T.p: default: return paddedValue(pad)
        }
    }

    BalancedTernaryInteger multiply(BalancedTernaryInteger that) {
        assert that != null
        if (that == ZERO)  return ZERO
        if (that == PLUS)  return this
        if (that == MINUS) return -this
        if (this.value.size() == 1 || sigTritCount(this) < sigTritCount(that)) {
            return that.multiply(this)
        }
        that.value.collect{ T.get(it) }[-1..(-value.size())].inject(INITIAL_PRODUCT_PARTS) { parts, multiplier ->
            [sum: parts.sum + partialProduct(multiplier, parts.pad), pad: parts.pad + T.z]
        }.sum
    }

    BigInteger asBigInteger() {
        value.collect{ T.get(it) }.inject(0) { i, trit -> i * 3 + trit.value }
    }

    def asType(Class c) {
        switch (c) {
            case Integer:              return asBigInteger() as Integer
            case Long:                 return asBigInteger() as Long
            case [BigInteger, Number]: return asBigInteger()
            case Boolean:              return this != ZERO
            case String:               return toString()
            default:                   return super.asType(c)
        }
    }

    boolean equals(Object that) {
        switch (that) {
            case BalancedTernaryInteger: return this.value == that?.value
            default:                     return super.equals(that)
        }
    }

    int hashCode() { this.value.hashCode() }

    String toString() { value }
}

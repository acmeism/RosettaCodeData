BigDecimal e(BigInteger limit, int scale) {
    BigDecimal e = BigDecimal.ONE.setScale(scale, HALF_UP);
    BigDecimal n;
    BigInteger term = BigInteger.ONE;
    while (term.compareTo(limit) <= 0) {
        n = new BigDecimal(String.valueOf(factorial(term)));
        e = e.add(BigDecimal.ONE.divide(n, scale, HALF_UP));
        term = term.add(BigInteger.ONE);
    }
    return e;
}

BigInteger factorial(BigInteger value) {
    if (value.compareTo(BigInteger.ONE) > 0) {
        return value.multiply(factorial(value.subtract(BigInteger.ONE)));
    } else {
        return BigInteger.ONE;
    }
}

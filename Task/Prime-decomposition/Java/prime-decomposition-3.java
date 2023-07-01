private static final BigInteger two = BigInteger.valueOf(2);

public List<BigInteger> primeDecomp(BigInteger a) {
    // impossible for values lower than 2
    if (a.compareTo(two) < 0) {
        return null;
    }

    //quickly handle even values
    List<BigInteger> result = new ArrayList<BigInteger>();
    while (a.and(BigInteger.ONE).equals(BigInteger.ZERO)) {
        a = a.shiftRight(1);
        result.add(two);
    }

    //left with odd values
    if (!a.equals(BigInteger.ONE)) {
        BigInteger b = BigInteger.valueOf(3);
        while (b.compareTo(a) < 0) {
            if (b.isProbablePrime(10)) {
                BigInteger[] dr = a.divideAndRemainder(b);
                if (dr[1].equals(BigInteger.ZERO)) {
                    result.add(b);
                    a = dr[0];
                }
            }
            b = b.add(two);
        }
        result.add(b); //b will always be prime here...
    }
    return result;
}

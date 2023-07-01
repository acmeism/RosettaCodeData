class DigitalRoot {
    static int[] calcDigitalRoot(String number, int base) {
        BigInteger bi = new BigInteger(number, base)
        int additivePersistence = 0
        if (bi.signum() < 0) {
            bi = bi.negate()
        }
        BigInteger biBase = BigInteger.valueOf(base)
        while (bi >= biBase) {
            number = bi.toString(base)
            bi = BigInteger.ZERO
            for (int i = 0; i < number.length(); i++) {
                bi = bi.add(new BigInteger(number.substring(i, i + 1), base))
            }
            additivePersistence++
        }
        return [additivePersistence, bi.intValue()]
    }

    static void main(String[] args) {
        for (String arg : [627615, 39390, 588225, 393900588225]) {
            int[] results = calcDigitalRoot(arg, 10)
            println("$arg has additive persistence ${results[0]} and digital root of ${results[1]}")
        }
    }
}

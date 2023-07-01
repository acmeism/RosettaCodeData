function run_factorize(input, output) {
    var n = new BigInteger(input.value, 10);
    var TWO = new BigInteger("2", 10);
    var divisor = new BigInteger("3", 10);
    var prod = false;

    if (n.compareTo(TWO) < 0)
        return;

    output.value = "";

    while (true) {
        var qr = n.divideAndRemainder(TWO);
        if (qr[1].equals(BigInteger.ZERO)) {
            if (prod)
                output.value += "*";
            else
                prod = true;
            output.value += "2";
            n = qr[0];
        }
        else
            break;
    }

    while (!n.equals(BigInteger.ONE)) {
        var qr = n.divideAndRemainder(divisor);
        if (qr[1].equals(BigInteger.ZERO)) {
            if (prod)
                output.value += "*";
            else
                prod = true;
            output.value += divisor;
            n = qr[0];
        }
        else
            divisor = divisor.add(TWO);
    }
}

import java.math.BigInteger;

public static BigInteger ack(BigInteger m, BigInteger n) {
    return m.equals(BigInteger.ZERO)
            ? n.add(BigInteger.ONE)
            : ack(m.subtract(BigInteger.ONE),
                        n.equals(BigInteger.ZERO) ? BigInteger.ONE : ack(m, n.subtract(BigInteger.ONE)));
}

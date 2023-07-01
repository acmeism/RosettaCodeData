import java.math.BigInteger;

class IntegerPower {
    public static void main(String[] args) {
        BigInteger power = BigInteger.valueOf(5).pow(BigInteger.valueOf(4).pow(BigInteger.valueOf(3).pow(2).intValueExact()).intValueExact());
        String str = power.toString();
        int len = str.length();
        System.out.printf("5**4**3**2 = %s...%s and has %d digits%n",
                str.substring(0, 20), str.substring(len - 20), len);
    }
}

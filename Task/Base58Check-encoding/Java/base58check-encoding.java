import java.math.BigInteger;
import java.util.List;

public class Base58CheckEncoding {
    private static final String ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";
    private static final BigInteger BIG0 = BigInteger.ZERO;
    private static final BigInteger BIG58 = BigInteger.valueOf(58);

    private static String convertToBase58(String hash) {
        return convertToBase58(hash, 16);
    }

    private static String convertToBase58(String hash, int base) {
        BigInteger x;
        if (base == 16 && hash.substring(0, 2).equals("0x")) {
            x = new BigInteger(hash.substring(2), 16);
        } else {
            x = new BigInteger(hash, base);
        }

        StringBuilder sb = new StringBuilder();
        while (x.compareTo(BIG0) > 0) {
            int r = x.mod(BIG58).intValue();
            sb.append(ALPHABET.charAt(r));
            x = x.divide(BIG58);
        }

        return sb.reverse().toString();
    }

    public static void main(String[] args) {
        String s = "25420294593250030202636073700053352635053786165627414518";
        String b = convertToBase58(s, 10);
        System.out.printf("%s -> %s\n", s, b);

        List<String> hashes = List.of(
            "0x61",
            "0x626262",
            "0x636363",
            "0x73696d706c792061206c6f6e6720737472696e67",
            "0x516b6fcd0f",
            "0xbf4f89001e670274dd",
            "0x572e4794",
            "0xecac89cad93923c02321",
            "0x10c8511e"
        );
        for (String hash : hashes) {
            String b58 = convertToBase58(hash);
            System.out.printf("%-56s -> %s\n", hash, b58);
        }
    }
}

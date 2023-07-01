import java.math.BigInteger;
import static java.util.Arrays.stream;
import java.util.*;
import static java.util.stream.Collectors.*;

public class Test3 {
    static BigInteger rank(int[] x) {
        String s = stream(x).mapToObj(String::valueOf).collect(joining("F"));
        return new BigInteger(s, 16);
    }

    static List<BigInteger> unrank(BigInteger n) {
        BigInteger sixteen = BigInteger.valueOf(16);
        String s = "";
        while (!n.equals(BigInteger.ZERO)) {
            s = "0123456789ABCDEF".charAt(n.mod(sixteen).intValue()) + s;
            n = n.divide(sixteen);
        }
        return stream(s.split("F")).map(x -> new BigInteger(x)).collect(toList());
    }

    public static void main(String[] args) {
        int[] s = {1, 2, 3, 10, 100, 987654321};
        System.out.println(Arrays.toString(s));
        System.out.println(rank(s));
        System.out.println(unrank(rank(s)));
    }
}

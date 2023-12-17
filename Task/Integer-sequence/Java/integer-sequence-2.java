import java.math.BigInteger;

public class Count {
    public static void main(String[] args) {
        for(BigInteger i = BigInteger.ONE; ;i = i.add(BigInteger.ONE)) System.out.println(i);
    }
}

import java.math.BigInteger;

public static long gcd(long a, long b){
   return BigInteger.valueOf(a).gcd(BigInteger.valueOf(b)).longValue();
}

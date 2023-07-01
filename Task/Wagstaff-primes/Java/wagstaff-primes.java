import java.math.BigInteger;

public class Main {
  public static void main(String[] args) {
    BigInteger d = new BigInteger("3"), a;
    int lmt = 25, sl, c = 0;
    for (int i = 3; i < 5808; ) {
      a = BigInteger.ONE.shiftLeft(i).add(BigInteger.ONE).divide(d);
      if (a.isProbablePrime(1)) {
        System.out.printf("%2d %4d ", ++c, i);
        String s = a.toString(); sl = s.length();
        if (sl < lmt) System.out.println(a);
        else System.out.println(s.substring(0, 11) + ".." + s.substring(sl - 11, sl) + " " + sl + " digits");
      }
      i = BigInteger.valueOf(i).nextProbablePrime().intValue();
    }
  }
}

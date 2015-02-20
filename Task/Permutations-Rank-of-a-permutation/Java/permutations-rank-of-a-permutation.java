import java.math.BigInteger;
import java.util.*;

class RankPermutation
{
  public static BigInteger getRank(int[] permutation)
  {
    int n = permutation.length;
    BitSet usedDigits = new BitSet();
    BigInteger rank = BigInteger.ZERO;
    for (int i = 0; i < n; i++)
    {
      rank = rank.multiply(BigInteger.valueOf(n - i));
      int digit = 0;
      int v = -1;
      while ((v = usedDigits.nextClearBit(v + 1)) < permutation[i])
        digit++;
      usedDigits.set(v);
      rank = rank.add(BigInteger.valueOf(digit));
    }
    return rank;
  }

  public static int[] getPermutation(int n, BigInteger rank)
  {
    int[] digits = new int[n];
    for (int digit = 2; digit <= n; digit++)
    {
      BigInteger divisor = BigInteger.valueOf(digit);
      digits[n - digit] = rank.mod(divisor).intValue();
      if (digit < n)
        rank = rank.divide(divisor);
    }
    BitSet usedDigits = new BitSet();
    int[] permutation = new int[n];
    for (int i = 0; i < n; i++)
    {
      int v = usedDigits.nextClearBit(0);
      for (int j = 0; j < digits[i]; j++)
        v = usedDigits.nextClearBit(v + 1);
      permutation[i] = v;
      usedDigits.set(v);
    }
    return permutation;
  }

  public static void main(String[] args)
  {
    for (int i = 0; i < 6; i++)
    {
      int[] permutation = getPermutation(3, BigInteger.valueOf(i));
      System.out.println(String.valueOf(i) + " --> " + Arrays.toString(permutation) + " --> " + getRank(permutation));
    }
    Random rnd = new Random();
    for (int n : new int[] { 12, 144 })
    {
      BigInteger factorial = BigInteger.ONE;
      for (int i = 2; i <= n; i++)
        factorial = factorial.multiply(BigInteger.valueOf(i));
      // Create 5 random samples
      System.out.println("n = " + n);
      for (int i = 0; i < 5; i++)
      {
        BigInteger rank = new BigInteger((factorial.bitLength() + 1) << 1, rnd);
        rank = rank.mod(factorial);
        int[] permutation = getPermutation(n, rank);
        System.out.println("  " + rank + " --> " + Arrays.toString(permutation) + " --> " + getRank(permutation));
      }
    }
  }

}

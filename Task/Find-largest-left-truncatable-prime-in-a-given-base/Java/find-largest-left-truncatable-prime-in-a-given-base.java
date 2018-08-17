import java.math.BigInteger;
import java.util.*;

class LeftTruncatablePrime
{
  private static List<BigInteger> getNextLeftTruncatablePrimes(BigInteger n, int radix, int millerRabinCertainty)
  {
    List<BigInteger> probablePrimes = new ArrayList<BigInteger>();
    String baseString = n.equals(BigInteger.ZERO) ? "" : n.toString(radix);
    for (int i = 1; i < radix; i++)
    {
      BigInteger p = new BigInteger(Integer.toString(i, radix) + baseString, radix);
      if (p.isProbablePrime(millerRabinCertainty))
        probablePrimes.add(p);
    }
    return probablePrimes;
  }

  public static BigInteger getLargestLeftTruncatablePrime(int radix, int millerRabinCertainty)
  {
    List<BigInteger> lastList = null;
    List<BigInteger> list = getNextLeftTruncatablePrimes(BigInteger.ZERO, radix, millerRabinCertainty);
    while (!list.isEmpty())
    {
      lastList = list;
      list = new ArrayList<BigInteger>();
      for (BigInteger n : lastList)
        list.addAll(getNextLeftTruncatablePrimes(n, radix, millerRabinCertainty));
    }
    if (lastList == null)
      return null;
    Collections.sort(lastList);
    return lastList.get(lastList.size() - 1);
  }

  public static void main(String[] args)
  {
    if (args.length != 2) {
      System.err.println("There must be exactly two command line arguments.");
      return;
    }
    int maxRadix;
    try {
      maxRadix = Integer.parseInt(args[0]);
      if (maxRadix < 3) throw new NumberFormatException();
    } catch (NumberFormatException e) {
      System.err.println("Radix must be an integer greater than 2.");
      return;
    }
    int millerRabinCertainty;
    try {
      millerRabinCertainty = Integer.parseInt(args[1]);
    } catch (NumberFormatException e) {
      System.err.println("Miiller-Rabin Certainty must be an integer.");
      return;
    }
    for (int radix = 3; radix <= maxRadix; radix++)
    {
      BigInteger largest = getLargestLeftTruncatablePrime(radix, millerRabinCertainty);
      System.out.print("n=" + radix + ": ");
      if (largest == null)
        System.out.println("No left-truncatable prime");
      else
        System.out.println(largest + " (in base " + radix + "): " + largest.toString(radix));
    }
  }

}

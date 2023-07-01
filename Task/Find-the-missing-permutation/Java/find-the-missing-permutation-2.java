public class FindMissingPermutation
{
  public static void main(String[] args)
  {
    String[] givenPermutations = { "ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD",
                                   "ADCB", "CDAB", "DABC", "BCAD", "CADB", "CDBA",
                                   "CBAD", "ABDC", "ADBC", "BDCA", "DCBA", "BACD",
                                   "BADC", "BDAC", "CBDA", "DBCA", "DCAB" };
    String characterSet = givenPermutations[0];
    // Compute n! * (n - 1) / 2
    int maxCode = characterSet.length() - 1;
    for (int i = characterSet.length(); i >= 3; i--)
      maxCode *= i;
    StringBuilder missingPermutation = new StringBuilder();
    for (int i = 0; i < characterSet.length(); i++)
    {
      int code = 0;
      for (String permutation : givenPermutations)
        code += characterSet.indexOf(permutation.charAt(i));
      missingPermutation.append(characterSet.charAt(maxCode - code));
    }
    System.out.println("Missing permutation: " + missingPermutation.toString());
  }
}

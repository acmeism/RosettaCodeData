import java.util.Comparator;
import java.util.Arrays;

public class Test {
  public static void main(String[] args) {
    String[] strings = {"Here", "are", "some", "sample", "strings", "to", "be", "sorted"};

    Arrays.sort(strings, new Comparator<String>() {
      public int compare(String s1, String s2) {
        int c = s2.length() - s1.length();
        if (c == 0)
          c = s1.compareToIgnoreCase(s2);
        return c;
      }
    });

    for (String s: strings)
      System.out.print(s + " ");
  }
}

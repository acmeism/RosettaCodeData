import java.text.BreakIterator;

public class Reverse {
  /* works with Java 20+ only
   * cf. https://bugs.openjdk.org/browse/JDK-8291660
   */
  public static StringBuilder graphemeReverse(String text) {
    BreakIterator boundary = BreakIterator.getCharacterInstance();
    boundary.setText(text);
    StringBuilder reversed = new StringBuilder();
    int end = boundary.last();
    int start = boundary.previous();
    while (start != BreakIterator.DONE) {
      reversed.append(text.substring(start, end));
      end = start;
      start = boundary.previous();
    }
    return reversed;
  }
  public static void main(String[] args) throws Exception {
    String a = "as⃝df̅";
    System.out.println(graphemeReverse(a)); // f̅ds⃝a
  }
}

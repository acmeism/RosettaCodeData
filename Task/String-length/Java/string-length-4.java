import java.text.BreakIterator;

public class Grapheme {
  public static void main(String[] args) {
    printLength("møøse");
    printLength("𝔘𝔫𝔦𝔠𝔬𝔡𝔢");
    printLength("J̲o̲s̲é̲");
  }

  public static void printLength(String s) {
    BreakIterator it = BreakIterator.getCharacterInstance();
    it.setText(s);
    int count = 0;
    while (it.next() != BreakIterator.DONE) {
      count++;
    }
    System.out.println("Grapheme length: " + count+ " " + s);
  }
}

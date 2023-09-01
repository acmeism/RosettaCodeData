public class SubstringTopAndTail {
  public static void main( String[] args ){
    var s = "\uD83D\uDC0Eabc\uD83D\uDC0E";  // Horse emoji, a, b, c, horse emoji: "🐎abc🐎"

    var sizeOfFirstChar = Character.isSurrogate(s.charAt(0)) ? 2 : 1;
    var sizeOfLastChar = Character.isSurrogate(s.charAt(s.length() - 1)) ? 2 : 1;

    var removeFirst = s.substring(sizeOfFirstChar);
    var removeLast = s.substring(0, s.length() - sizeOfLastChar);
    var removeBoth = s.substring(sizeOfFirstChar, s.length() - sizeOfLastChar);

    System.out.println(removeFirst);
    System.out.println(removeLast);
    System.out.println(removeBoth);
  }
}

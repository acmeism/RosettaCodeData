import java.util.function.IntPredicate;

public class StripControlCodes {

    public static void main(String[] args) {
        String s = "\u0000\n abc\u00E9def\u007F";
        System.out.println(stripChars(s, c -> c > '\u001F' && c != '\u007F'));
        System.out.println(stripChars(s, c -> c > '\u001F' && c < '\u007F'));
    }

    static String stripChars(String s, IntPredicate include) {
        return s.codePoints().filter(include::test).collect(StringBuilder::new,
                StringBuilder::appendCodePoint, StringBuilder::append).toString();
    }
}

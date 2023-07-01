import java.util.stream.Stream;

public class NameGame {
    private static void printVerse(String name) {
        StringBuilder sb = new StringBuilder(name.toLowerCase());
        sb.setCharAt(0, Character.toUpperCase(sb.charAt(0)));
        String x = sb.toString();
        String y = "AEIOU".indexOf(x.charAt(0)) > -1 ? x.toLowerCase() : x.substring(1);
        String b = "b" + y;
        String f = "f" + y;
        String m = "m" + y;
        switch (x.charAt(0)) {
            case 'B':
                b = y;
                break;
            case 'F':
                f = y;
                break;
            case 'M':
                m = y;
                break;
            default:
                // no adjustment needed
                break;
        }
        System.out.printf("%s, %s, bo-%s\n", x, x, b);
        System.out.printf("Banana-fana fo-%s\n", f);
        System.out.printf("Fee-fi-mo-%s\n", m);
        System.out.printf("%s!\n\n", x);
    }

    public static void main(String[] args) {
        Stream.of("Gary", "Earl", "Billy", "Felix", "Mary", "Steve").forEach(NameGame::printVerse);
    }
}

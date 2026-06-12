import static java.util.Arrays.*;
import static java.util.Arrays.*;
import static java.lang.System.out;

public class NYSIIS {

    final static String[][] first = {{"MAC", "MCC"}, {"KN", "N"}, {"K", "C"},
    {"PH", "FF"}, {"PF", "FF"}, {"SCH", "SSS"}};

    final static String[][] last = {{"EE", "Y"}, {"IE", "Y"}, {"DT", "D"},
    {"RT", "D"}, {"RD", "D"}, {"NT", "D"}, {"ND", "D"}};

    final static String Vowels = "AEIOU";

    public static void main(String[] args) {
        stream(args).parallel().map(n -> transcode(n)).forEach(out::println);
    }

    static String transcode(String s) {
        int len = s.length();
        StringBuilder sb = new StringBuilder(len);

        for (int i = 0; i < len; i++) {
            char c = s.charAt(i);
            if (c >= 'a' && c <= 'z')
                sb.append((char) (c - 32));
            else if (c >= 'A' && c <= 'Z')
                sb.append(c);
        }

        replace(sb, 0, first);
        replace(sb, sb.length() - 2, last);

        len = sb.length();
        sb.append(" ");
        for (int i = 1; i < len; i++) {
            char prev = sb.charAt(i - 1);
            char curr = sb.charAt(i);
            char next = sb.charAt(i + 1);

            if (curr == 'E' && next == 'V')
                sb.replace(i, i + 2, "AF");

            else if (isVowel(curr))
                sb.setCharAt(i, 'A');

            else if (curr == 'Q')
                sb.setCharAt(i, 'G');

            else if (curr == 'Z')
                sb.setCharAt(i, 'S');

            else if (curr == 'M')
                sb.setCharAt(i, 'N');

            else if (curr == 'K' && next == 'N')
                sb.setCharAt(i, 'N');

            else if (curr == 'K')
                sb.setCharAt(i, 'C');

            else if (sb.indexOf("SCH", i) == i)
                sb.replace(i, i + 3, "SSS");

            else if (curr == 'P' && next == 'H')
                sb.replace(i, i + 2, "FF");

            else if (curr == 'H' && (!isVowel(prev) || !isVowel(next)))
                sb.setCharAt(i, prev);

            else if (curr == 'W' && isVowel(prev))
                sb.setCharAt(i, prev);

            if (sb.charAt(i) == prev) {
                sb.deleteCharAt(i--);
                len--;
            }
        }
        sb.setLength(sb.length() - 1); // We've added a space

        int lastPos = sb.length() - 1;
        if (lastPos > 1) {

            if (sb.charAt(lastPos) == 'S') {
                sb.setLength(lastPos);
                lastPos --;
            }
            if (sb.lastIndexOf("AY") == lastPos - 1) {
                sb.delete(lastPos - 1, lastPos + 1).append("Y");
                lastPos --;
            }
            if (sb.charAt(lastPos) == 'A') {
                sb.setLength(lastPos);
                lastPos --;
            }
        }

        if (sb.length() > 6)
            sb.insert(6, '[').append(']');

        return String.format("%s -> %s", s, sb);
    }

    private static void replace(StringBuilder sb, int start, String[][] maps) {
        if (start >= 0)
            for (String[] map : maps) {
                if (sb.indexOf(map[0]) == start) {
                    sb.replace(start, start + map[0].length(), map[1]);
                    break;
                }
            }
    }

    private static boolean isVowel(char c) {
        return Vowels.indexOf(c) != -1;
    }
}

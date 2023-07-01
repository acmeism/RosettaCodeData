import java.util.*;

public class MultiSplit {

    public static void main(String[] args) {
        System.out.println("Regex split:");
        System.out.println(Arrays.toString("a!===b=!=c".split("==|!=|=")));

        System.out.println("\nManual split:");
        for (String s : multiSplit("a!===b=!=c", new String[]{"==", "!=", "="}))
            System.out.printf("\"%s\" ", s);
    }

    static List<String> multiSplit(String txt, String[] separators) {
        List<String> result = new ArrayList<>();
        int txtLen = txt.length(), from = 0;

        for (int to = 0; to < txtLen; to++) {
            for (String sep : separators) {
                int sepLen = sep.length();
                if (txt.regionMatches(to, sep, 0, sepLen)) {
                    result.add(txt.substring(from, to));
                    from = to + sepLen;
                    to = from - 1; // compensate for the increment
                    break;
                }
            }
        }
        if (from < txtLen)
            result.add(txt.substring(from));
        return result;
    }
}

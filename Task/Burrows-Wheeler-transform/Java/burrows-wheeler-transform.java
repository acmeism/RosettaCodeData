import java.util.ArrayList;
import java.util.List;

public class BWT {
    private static final String STX = "\u0002";
    private static final String ETX = "\u0003";

    private static String bwt(String s) {
        if (s.contains(STX) || s.contains(ETX)) {
            throw new IllegalArgumentException("String cannot contain STX or ETX");
        }

        String ss = STX + s + ETX;
        List<String> table = new ArrayList<>();
        for (int i = 0; i < ss.length(); i++) {
            String before = ss.substring(i);
            String after = ss.substring(0, i);
            table.add(before + after);
        }
        table.sort(String::compareTo);

        StringBuilder sb = new StringBuilder();
        for (String str : table) {
            sb.append(str.charAt(str.length() - 1));
        }
        return sb.toString();
    }

    private static String ibwt(String r) {
        int len = r.length();
        List<String> table = new ArrayList<>();
        for (int i = 0; i < len; ++i) {
            table.add("");
        }
        for (int j = 0; j < len; ++j) {
            for (int i = 0; i < len; ++i) {
                table.set(i, r.charAt(i) + table.get(i));
            }
            table.sort(String::compareTo);
        }
        for (String row : table) {
            if (row.endsWith(ETX)) {
                return row.substring(1, len - 1);
            }
        }
        return "";
    }

    private static String makePrintable(String s) {
        // substitute ^ for STX and | for ETX to print results
        return s.replace(STX, "^").replace(ETX, "|");
    }

    public static void main(String[] args) {
        List<String> tests = List.of(
            "banana",
            "appellee",
            "dogwood",
            "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
            "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
            "\u0002ABC\u0003"
        );
        for (String test : tests) {
            System.out.println(makePrintable(test));
            System.out.print(" --> ");
            String t = "";
            try {
                t = bwt(test);
                System.out.println(makePrintable(t));
            } catch (IllegalArgumentException e) {
                System.out.println("ERROR: " + e.getMessage());
            }
            String r = ibwt(t);
            System.out.printf(" --> %s\n\n", r);
        }
    }
}

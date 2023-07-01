import java.util.*;

public class TokenizeStringWithEscaping {

    public static void main(String[] args) {
        String sample = "one^|uno||three^^^^|four^^^|^cuatro|";
        char separator = '|';
        char escape = '^';

        System.out.println(sample);
        try {
            System.out.println(tokenizeString(sample, separator, escape));
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public static List<String> tokenizeString(String s, char sep, char escape)
            throws Exception {
        List<String> tokens = new ArrayList<>();
        StringBuilder sb = new StringBuilder();

        boolean inEscape = false;
        for (char c : s.toCharArray()) {
            if (inEscape) {
                inEscape = false;
            } else if (c == escape) {
                inEscape = true;
                continue;
            } else if (c == sep) {
                tokens.add(sb.toString());
                sb.setLength(0);
                continue;
            }
            sb.append(c);
        }
        if (inEscape)
            throw new Exception("Invalid terminal escape");

        tokens.add(sb.toString());

        return tokens;
    }
}

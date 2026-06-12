import java.util.function.BiFunction;

public class Redactor {

    public static String redact(String source, String word, boolean partial, boolean insensitive, boolean overkill) {
        StringBuilder temp = new StringBuilder(source);
        BiFunction<Character, Character, Boolean> different = (s, w) -> {
            if (insensitive) {
                return Character.toUpperCase(s) != Character.toUpperCase(w);
            } else {
                return s != w;
            }
        };

        for (int i = 0; i < temp.length() - word.length() + 1; i++) {
            boolean match = true;
            for (int j = 0; j < word.length(); j++) {
                if (different.apply(temp.charAt(i + j), word.charAt(j))) {
                    match = false;
                    break;
                }
            }
            if (match) {
                int beg = i;
                int end = i + word.length();
                if (!partial) {
                    if (beg > 0 && isWordChar(temp.charAt(beg - 1))) {
                        continue;
                    }
                    if (end < temp.length() && isWordChar(temp.charAt(end))) {
                        continue;
                    }
                }
                if (overkill) {
                    while (beg > 0 && isWordChar(temp.charAt(beg - 1))) {
                        beg--;
                    }
                    while (end < temp.length() && isWordChar(temp.charAt(end))) {
                        end++;
                    }
                }
                for (int k = beg; k < end; k++) {
                    temp.setCharAt(k, 'X');
                }
            }
        }
        return temp.toString();
    }

    private static boolean isWordChar(char c) {
        return c == '-' || Character.isLetter(c);
    }

    public static void example(String source, String word) {
        System.out.println("Redact " + word);
        System.out.println("[w|s|n] " + redact(source, word, false, false, false));
        System.out.println("[w|i|n] " + redact(source, word, false, true, false));
        System.out.println("[p|s|n] " + redact(source, word, true, false, false));
        System.out.println("[p|i|n] " + redact(source, word, true, true, false));
        System.out.println("[p|s|o] " + redact(source, word, true, false, true));
        System.out.println("[p|i|o] " + redact(source, word, true, true, true));
        System.out.println();
    }

    public static void main(String[] args) {
        String text = "Tom? Toms bottom tomato is in his stomach while playing the \"Tom-tom\" brand tom-toms. That's so tom";
        example(text, "Tom");
        example(text, "tom");
    }
}


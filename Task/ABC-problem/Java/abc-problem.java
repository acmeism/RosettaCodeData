import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class ABC {

    public static void main(String[] args) {
        List<String> blocks = Arrays.asList(
                "BO", "XK", "DQ", "CP", "NA",
                "GT", "RE", "TG", "QD", "FS",
                "JW", "HU", "VI", "AN", "OB",
                "ER", "FS", "LY", "PC", "ZM");

        for (String word : Arrays.asList("", "A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE")) {
            System.out.printf("%s: %s%n", word.isEmpty() ? "\"\"" : word, canMakeWord(word, blocks));
        }
    }

    public static boolean canMakeWord(String word, List<String> blocks) {
        if (word.isEmpty())
            return true;

        char c = word.charAt(0);
        for (int i = 0; i < blocks.size(); i++) {
            String b = blocks.get(i);
            if (b.charAt(0) != c && b.charAt(1) != c)
                continue;
            Collections.swap(blocks, 0, i);
            if (canMakeWord(word.substring(1), blocks.subList(1, blocks.size())))
                return true;
            Collections.swap(blocks, 0, i);
        }

        return false;
    }
}

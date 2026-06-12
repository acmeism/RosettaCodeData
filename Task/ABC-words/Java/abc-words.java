import java.io.BufferedReader;
import java.io.FileReader;

public class AbcWords {
    public static void main(String[] args) {
        String fileName = "unixdict.txt";
        String chars = "abc";
        for (int i = 0; i + 1 < args.length
                && args[i].length() > 1
                && args[i].charAt(0) == '-'; ++i) {
            switch (args[i].charAt(1)) {
            case 'f':
                fileName = args[++i];
                break;
            case 'c':
                chars = args[++i];
                break;
            }
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            int n = 0;
            while ((line = reader.readLine()) != null) {
                if (match(line, chars)) {
                    ++n;
                    System.out.printf("%3d: %-20s", n, line);
                    if (n % 3 == 0)
                        System.out.println();
                }
            }
            if (n > 0 && n % 3 != 0)
                System.out.println();
        } catch (Exception e)  {
            e.printStackTrace();
        }
    }

    // Returns true if word contains every character in chars in the
    // same order. chars may contain the same character more than once.
    private static boolean match(String word, String chars) {
        int length = chars.length();
        boolean[] seen = new boolean[length];
        int wordLength = word.length();
        for (int w = 0; w < wordLength; ++w) {
            char ch = word.charAt(w);
            int index = -1;
            for (int c = 0; c < length; ++c) {
                if (ch == chars.charAt(c) && !seen[c]) {
                    index = c;
                    break;
                }
            }
            if (index == -1)
                continue;
            if (index + 1 == length)
                return index == 0 ? true : seen[index - 1];
            if (index > 0 && !seen[index - 1])
                return false;
            seen[index] = true;
        }
        return false;
    }
}

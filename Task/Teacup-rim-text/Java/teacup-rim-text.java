import java.io.*;
import java.util.*;

public class Teacup {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("usage: java Teacup dictionary");
            System.exit(1);
        }
        try {
            findTeacupWords(loadDictionary(args[0]));
        } catch (Exception ex) {
            System.err.println(ex.getMessage());
        }
    }

    // The file is expected to contain one lowercase word per line
    private static Set<String> loadDictionary(String fileName) throws IOException {
        Set<String> words = new TreeSet<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String word;
            while ((word = reader.readLine()) != null)
                words.add(word);
            return words;
        }
    }

    private static void findTeacupWords(Set<String> words) {
        List<String> teacupWords = new ArrayList<>();
        Set<String> found = new HashSet<>();
        for (String word : words) {
            int len = word.length();
            if (len < 3 || found.contains(word))
                continue;
            teacupWords.clear();
            teacupWords.add(word);
            char[] chars = word.toCharArray();
            for (int i = 0; i < len - 1; ++i) {
                String rotated = new String(rotate(chars));
                if (rotated.equals(word) || !words.contains(rotated))
                    break;
                teacupWords.add(rotated);
            }
            if (teacupWords.size() == len) {
                found.addAll(teacupWords);
                System.out.print(word);
                for (int i = 1; i < len; ++i)
                    System.out.print(" " + teacupWords.get(i));
                System.out.println();
            }
        }
    }

    private static char[] rotate(char[] ch) {
        char c = ch[0];
        System.arraycopy(ch, 1, ch, 0, ch.length - 1);
        ch[ch.length - 1] = c;
        return ch;
    }
}

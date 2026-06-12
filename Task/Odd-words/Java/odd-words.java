import java.io.*;
import java.util.*;

public class OddWords {
    public static void main(String[] args) {
        try {
            Set<String> dictionary = new TreeSet<>();
            final int minLength = 5;
            String fileName = "unixdict.txt";
            if (args.length != 0)
                fileName = args[0];
            try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.length() >= minLength)
                        dictionary.add(line);
                }
            }
            StringBuilder word1 = new StringBuilder();
            StringBuilder word2 = new StringBuilder();
            List<StringPair> evenWords = new ArrayList<>();
            List<StringPair> oddWords = new ArrayList<>();
            for (String word : dictionary) {
                int length = word.length();
                if (length < minLength + 2 * (minLength/2))
                    continue;
                word1.setLength(0);
                word2.setLength(0);
                for (int i = 0; i < length; ++i) {
                    if ((i & 1) == 0)
                        word1.append(word.charAt(i));
                    else
                        word2.append(word.charAt(i));
                }
                String oddWord = word1.toString();
                String evenWord = word2.toString();
                if (dictionary.contains(oddWord))
                    oddWords.add(new StringPair(word, oddWord));
                if (dictionary.contains(evenWord))
                    evenWords.add(new StringPair(word, evenWord));
            }
            System.out.println("Odd words:");
            printWords(oddWords);
            System.out.println("\nEven words:");
            printWords(evenWords);
        } catch (Exception e)  {
            e.printStackTrace();
        }
    }

    private static void printWords(List<StringPair> strings) {
        int n = 1;
        for (StringPair pair : strings) {
            System.out.printf("%2d: %-14s%s\n", n++,
                                    pair.string1, pair.string2);
        }
    }

    private static class StringPair {
        private String string1;
        private String string2;
        private StringPair(String s1, String s2) {
            string1 = s1;
            string2 = s2;
        }
    }
}

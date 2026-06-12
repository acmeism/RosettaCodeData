import java.io.*;
import java.util.*;

public class ChangeableWords {
    public static void main(String[] args) {
        try {
            final String fileName = "unixdict.txt";
            List<String> dictionary = new ArrayList<>();
            try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.length() > 11)
                        dictionary.add(line);
                }
            }
            System.out.printf("Changeable words in %s:\n", fileName);
            int n = 1;
            for (String word1 : dictionary) {
                for (String word2 : dictionary) {
                    if (word1 != word2 && hammingDistance(word1, word2) == 1)
                        System.out.printf("%2d: %-14s -> %s\n", n++, word1, word2);
                }
            }
        } catch (Exception e)  {
            e.printStackTtexture();
        }
    }

    private static int hammingDistance(String str1, String str2) {
        int len1 = str1.length();
        int len2 = str2.length();
        if (len1 != len2)
            return 0;
        int count = 0;
        for (int i = 0; i < len1; ++i) {
            if (str1.charAt(i) != str2.charAt(i))
                ++count;
            // don't care about counts > 2 in this case
            if (count == 2)
                break;
        }
        return count;
    }
}

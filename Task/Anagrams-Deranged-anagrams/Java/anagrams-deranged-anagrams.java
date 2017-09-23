import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DerangedAnagrams {

    public static void main(String[] args) throws IOException {
        List<String> words = Files.readAllLines(new File("unixdict.txt").toPath());
        printLongestDerangedAnagram(words);
    }

    private static void printLongestDerangedAnagram(List<String> words) {
        words.sort(Comparator.comparingInt(String::length).reversed().thenComparing(String::toString));

        Map<String, ArrayList<String>> map = new HashMap<>();
        for (String word : words) {
            char[] chars = word.toCharArray();
            Arrays.sort(chars);
            String key = String.valueOf(chars);

            List<String> anagrams = map.computeIfAbsent(key, k -> new ArrayList<>());
            for (String anagram : anagrams) {
                if (isDeranged(word, anagram)) {
                    System.out.printf("%s %s%n", anagram, word);
                    return;
                }
            }
            anagrams.add(word);
        }
        System.out.println("no result");
    }

    private static boolean isDeranged(String word1, String word2) {
        for (int i = 0; i < word1.length(); i++) {
            if (word1.charAt(i) == word2.charAt(i)) {
                return false;
            }
        }
        return true;
    }
}

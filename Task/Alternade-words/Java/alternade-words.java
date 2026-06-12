import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Set;
import java.util.TreeSet;

class AlternadeWords {
    static char[] vowels = "aeiouy".toCharArray();
    static String alphabet;

    static {
        alphabet = "";
        for (int index = 0; index < 26; index++)
            alphabet += (char) (index + 'a');
    }

    boolean alphabetic(String string) {
        for (char character : string.toCharArray()) {
            if (!alphabet.contains(String.valueOf(character)))
                return false;
        }
        return true;
    }

    boolean containsVowel(String string) {
        for (char vowel : vowels) {
            if (string.contains(String.valueOf(vowel)))
                return true;
        }
        return false;
    }

    void alternateWords() throws IOException {
        Set<String> dictionary = new TreeSet<>();
        try (BufferedReader reader = new BufferedReader(new FileReader("unixdict.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!alphabetic(line) || !containsVowel(line))
                    continue;
                dictionary.add(line);
            }
        }
        StringBuilder wordA = new StringBuilder();
        StringBuilder wordB = new StringBuilder();
        for (String word : dictionary) {
            int length = word.length();
            if (length < 6)
                continue;
            wordA.setLength(0);
            wordB.setLength(0);
            for (int index = 0; index < length; index += 2) {
                wordA.append(word.charAt(index));
                if (index + 1 < length)
                    wordB.append(word.charAt(index + 1));
            }
            if (dictionary.contains(wordA.toString()))
                if (dictionary.contains(wordB.toString()))
                    System.out.printf("%-15s%5s %s%n", word, wordA, wordB);
        }
    }
}

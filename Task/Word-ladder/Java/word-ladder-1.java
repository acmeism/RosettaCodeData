import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.stream.IntStream;

public class WordLadder {
    private static int distance(String s1, String s2) {
        assert s1.length() == s2.length();
        return (int) IntStream.range(0, s1.length())
            .filter(i -> s1.charAt(i) != s2.charAt(i))
            .count();
    }

    private static void wordLadder(Map<Integer, Set<String>> words, String fw, String tw) {
        wordLadder(words, fw, tw, 8);
    }

    private static void wordLadder(Map<Integer, Set<String>> words, String fw, String tw, int limit) {
        if (fw.length() != tw.length()) {
            throw new IllegalArgumentException("From word and to word must have the same length");
        }

        Set<String> ws = words.get(fw.length());
        if (ws.contains(fw)) {
            List<String> primeList = new ArrayList<>();
            primeList.add(fw);

            PriorityQueue<List<String>> queue = new PriorityQueue<>((chain1, chain2) -> {
                int cmp1 = Integer.compare(chain1.size(), chain2.size());
                if (cmp1 == 0) {
                    String last1 = chain1.get(chain1.size() - 1);
                    int d1 = distance(last1, tw);

                    String last2 = chain2.get(chain2.size() - 1);
                    int d2 = distance(last2, tw);

                    return Integer.compare(d1, d2);
                }
                return cmp1;
            });
            queue.add(primeList);

            while (queue.size() > 0) {
                List<String> curr = queue.remove();
                if (curr.size() > limit) {
                    continue;
                }

                String last = curr.get(curr.size() - 1);
                for (String word : ws) {
                    if (distance(last, word) == 1) {
                        if (word.equals(tw)) {
                            curr.add(word);
                            System.out.println(String.join(" -> ", curr));
                            return;
                        }

                        if (!curr.contains(word)) {
                            List<String> cp = new ArrayList<>(curr);
                            cp.add(word);
                            queue.add(cp);
                        }
                    }
                }
            }
        }

        System.err.printf("Cannot turn `%s` into `%s`%n", fw, tw);
    }

    public static void main(String[] args) throws IOException {
        Map<Integer, Set<String>> words = new HashMap<>();
        for (String line : Files.readAllLines(Path.of("unixdict.txt"))) {
            Set<String> wl = words.computeIfAbsent(line.length(), HashSet::new);
            wl.add(line);
        }

        wordLadder(words, "boy", "man");
        wordLadder(words, "girl", "lady");
        wordLadder(words, "john", "jane");
        wordLadder(words, "child", "adult");
        wordLadder(words, "cat", "dog");
        wordLadder(words, "lead", "gold");
        wordLadder(words, "white", "black");
        wordLadder(words, "bubble", "tickle", 12);
    }
}

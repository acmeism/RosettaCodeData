import java.io.*;
import java.util.*;

public class WordLadder {
    public static void main(String[] args) {
        try {
            Map<Integer, List<String>> words = new HashMap<>();
            try (BufferedReader reader = new BufferedReader(new FileReader("unixdict.txt"))) {
                String line;
                while ((line = reader.readLine()) != null)
                    words.computeIfAbsent(line.length(), k -> new ArrayList<String>()).add(line);
            }
            wordLadder(words, "boy", "man");
            wordLadder(words, "girl", "lady");
            wordLadder(words, "john", "jane");
            wordLadder(words, "child", "adult");
            wordLadder(words, "cat", "dog");
            wordLadder(words, "lead", "gold");
            wordLadder(words, "white", "black");
            wordLadder(words, "bubble", "tickle");
        } catch (Exception e)  {
            e.printStackTrace();
        }
    }

    // Returns true if strings s1 and s2 differ by one character.
    private static boolean oneAway(String s1, String s2) {
        if (s1.length() != s2.length())
            return false;
        boolean result = false;
        for (int i = 0, n = s1.length(); i != n; ++i) {
            if (s1.charAt(i) != s2.charAt(i)) {
                if (result)
                    return false;
                result = true;
            }
        }
        return result;
    }

    // If possible, print the shortest chain of single-character modifications that
    // leads from "from" to "to", with each intermediate step being a valid word.
    // This is an application of breadth-first search.
    private static void wordLadder(Map<Integer, List<String>> words, String from, String to) {
        List<String> w = words.get(from.length());
        if (w != null) {
            Deque<String> poss = new ArrayDeque<>(w);
            Deque<String> f = new ArrayDeque<String>();
            f.add(from);
            Deque<Deque<String>> queue = new ArrayDeque<>();
            queue.add(f);
            while (!queue.isEmpty()) {
                Deque<String> curr = queue.poll();
                for (Iterator<String> i = poss.iterator(); i.hasNext(); ) {
                    String str = i.next();
                    if (!oneAway(str, curr.getLast()))
                        continue;
                    if (to.equals(str)) {
                        curr.add(to);
                        System.out.println(String.join(" -> ", curr));
                        return;
                    }
                    Deque<String> temp = new ArrayDeque<>(curr);
                    temp.add(str);
                    queue.add(temp);
                    i.remove();
                }
            }
        }
        System.out.printf("%s into %s cannot be done.\n", from, to);
    }
}

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class WordBreak {

    public static void main(String[] args) {
        List<String> dict = Arrays.asList("a", "aa", "b", "ab", "aab");
        for ( String testString : Arrays.asList("aab", "aa b") ) {
            List<List<String>> matches = wordBreak(testString, dict);
            System.out.printf("String = %s, Dictionary = %s.  Solutions = %d:%n", testString, dict, matches.size());
            for ( List<String> match : matches ) {
                System.out.printf(" Word Break = %s%n", match);
            }
            System.out.printf("%n");
        }
        dict = Arrays.asList("abc", "a", "ac", "b", "c", "cb", "d");
        for ( String testString : Arrays.asList("abcd", "abbc", "abcbcd", "acdbc", "abcdd") ) {
            List<List<String>> matches = wordBreak(testString, dict);
            System.out.printf("String = %s, Dictionary = %s.  Solutions = %d:%n", testString, dict, matches.size());
            for ( List<String> match : matches ) {
                System.out.printf(" Word Break = %s%n", match);
            }
            System.out.printf("%n");
        }
    }

    private static List<List<String>> wordBreak(String s, List<String> dictionary) {
        List<List<String>> matches = new ArrayList<>();
        Queue<Node> queue = new LinkedList<>();
        queue.add(new Node(s));
        while ( ! queue.isEmpty() ) {
            Node node = queue.remove();
            //  Check if fully parsed
            if ( node.val.length() == 0 ) {
                matches.add(node.parsed);
            }
            else {
                for ( String word : dictionary ) {
                    //  Check for match
                    if ( node.val.startsWith(word) ) {
                        String valNew = node.val.substring(word.length(), node.val.length());
                        List<String> parsedNew = new ArrayList<>();
                        parsedNew.addAll(node.parsed);
                        parsedNew.add(word);
                        queue.add(new Node(valNew, parsedNew));
                    }
                }
            }
        }
        return matches;
    }

    private static class Node {
        private String val;  //  Current unmatched string
        private List<String> parsed;  //  Matches in dictionary
        public Node(String initial) {
            val = initial;
            parsed = new ArrayList<>();
        }
        public Node(String s, List<String> p) {
            val = s;
            parsed = p;
        }
    }

}

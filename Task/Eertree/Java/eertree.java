import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Eertree {
    public static void main(String[] args) {
        List<Node> tree = eertree("eertree");
        List<String> result = subPalindromes(tree);
        System.out.println(result);
    }

    private static class Node {
        int length;
        Map<Character, Integer> edges = new HashMap<>();
        int suffix;

        public Node(int length) {
            this.length = length;
        }

        public Node(int length, Map<Character, Integer> edges, int suffix) {
            this.length = length;
            this.edges = edges != null ? edges : new HashMap<>();
            this.suffix = suffix;
        }
    }

    private static final int EVEN_ROOT = 0;
    private static final int ODD_ROOT = 1;

    private static List<Node> eertree(String s) {
        List<Node> tree = new ArrayList<>();
        tree.add(new Node(0, null, ODD_ROOT));
        tree.add(new Node(-1, null, ODD_ROOT));
        int suffix = ODD_ROOT;
        int n, k;
        for (int i = 0; i < s.length(); ++i) {
            char c = s.charAt(i);
            for (n = suffix; ; n = tree.get(n).suffix) {
                k = tree.get(n).length;
                int b = i - k - 1;
                if (b >= 0 && s.charAt(b) == c) {
                    break;
                }
            }
            if (tree.get(n).edges.containsKey(c)) {
                suffix = tree.get(n).edges.get(c);
                continue;
            }
            suffix = tree.size();
            tree.add(new Node(k + 2));
            tree.get(n).edges.put(c, suffix);
            if (tree.get(suffix).length == 1) {
                tree.get(suffix).suffix = 0;
                continue;
            }
            while (true) {
                n = tree.get(n).suffix;
                int b = i - tree.get(n).length - 1;
                if (b >= 0 && s.charAt(b) == c) {
                    break;
                }
            }
            tree.get(suffix).suffix = tree.get(n).edges.get(c);
        }
        return tree;
    }

    private static List<String> subPalindromes(List<Node> tree) {
        List<String> s = new ArrayList<>();
        subPalindromes_children(0, "", tree, s);
        for (Map.Entry<Character, Integer> cm : tree.get(1).edges.entrySet()) {
            String ct = String.valueOf(cm.getKey());
            s.add(ct);
            subPalindromes_children(cm.getValue(), ct, tree, s);
        }
        return s;
    }

    // nested methods are a pain, even if lambdas make that possible for Java
    private static void subPalindromes_children(final int n, final String p, final List<Node> tree, List<String> s) {
        for (Map.Entry<Character, Integer> cm : tree.get(n).edges.entrySet()) {
            Character c = cm.getKey();
            Integer m = cm.getValue();
            String pl = c + p + c;
            s.add(pl);
            subPalindromes_children(m, pl, tree, s);
        }
    }
}

import java.util.ArrayList;
import java.util.List;

public class SuffixTreeProblem {
    private static class Node {
        String sub = "";                       // a substring of the input string
        List<Integer> ch = new ArrayList<>();  // list of child nodes
    }

    private static class SuffixTree {
        private List<Node> nodes = new ArrayList<>();

        public SuffixTree(String str) {
            nodes.add(new Node());
            for (int i = 0; i < str.length(); ++i) {
                addSuffix(str.substring(i));
            }
        }

        private void addSuffix(String suf) {
            int n = 0;
            int i = 0;
            while (i < suf.length()) {
                char b = suf.charAt(i);
                List<Integer> children = nodes.get(n).ch;
                int x2 = 0;
                int n2;
                while (true) {
                    if (x2 == children.size()) {
                        // no matching child, remainder of suf becomes new node.
                        n2 = nodes.size();
                        Node temp = new Node();
                        temp.sub = suf.substring(i);
                        nodes.add(temp);
                        children.add(n2);
                        return;
                    }
                    n2 = children.get(x2);
                    if (nodes.get(n2).sub.charAt(0) == b) break;
                    x2++;
                }
                // find prefix of remaining suffix in common with child
                String sub2 = nodes.get(n2).sub;
                int j = 0;
                while (j < sub2.length()) {
                    if (suf.charAt(i + j) != sub2.charAt(j)) {
                        // split n2
                        int n3 = n2;
                        // new node for the part in common
                        n2 = nodes.size();
                        Node temp = new Node();
                        temp.sub = sub2.substring(0, j);
                        temp.ch.add(n3);
                        nodes.add(temp);
                        nodes.get(n3).sub = sub2.substring(j);  // old node loses the part in common
                        nodes.get(n).ch.set(x2, n2);
                        break;  // continue down the tree
                    }
                    j++;
                }
                i += j;  // advance past part in common
                n = n2;  // continue down the tree
            }
        }

        public void visualize() {
            if (nodes.isEmpty()) {
                System.out.println("<empty>");
                return;
            }
            visualize_f(0, "");
        }

        private void visualize_f(int n, String pre) {
            List<Integer> children = nodes.get(n).ch;
            if (children.isEmpty()) {
                System.out.println("- " + nodes.get(n).sub);
                return;
            }
            System.out.println("┐ " + nodes.get(n).sub);
            for (int i = 0; i < children.size() - 1; i++) {
                Integer c = children.get(i);
                System.out.print(pre + "├─");
                visualize_f(c, pre + "│ ");
            }
            System.out.print(pre + "└─");
            visualize_f(children.get(children.size() - 1), pre + "  ");
        }
    }

    public static void main(String[] args) {
        new SuffixTree("banana$").visualize();
    }
}

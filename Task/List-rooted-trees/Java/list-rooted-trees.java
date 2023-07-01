import java.util.ArrayList;
import java.util.List;

public class ListRootedTrees {
    private static final List<Long> TREE_LIST = new ArrayList<>();

    private static final List<Integer> OFFSET = new ArrayList<>();

    static {
        for (int i = 0; i < 32; i++) {
            if (i == 1) {
                OFFSET.add(1);
            } else {
                OFFSET.add(0);
            }
        }
    }

    private static void append(long t) {
        TREE_LIST.add(1 | (t << 1));
    }

    private static void show(long t, int l) {
        while (l-- > 0) {
            if (t % 2 == 1) {
                System.out.print('(');
            } else {
                System.out.print(')');
            }
            t = t >> 1;
        }
    }

    private static void listTrees(int n) {
        for (int i = OFFSET.get(n); i < OFFSET.get(n + 1); i++) {
            show(TREE_LIST.get(i), n * 2);
            System.out.println();
        }
    }

    private static void assemble(int n, long t, int sl, int pos, int rem) {
        if (rem == 0) {
            append(t);
            return;
        }

        var pp = pos;
        var ss = sl;

        if (sl > rem) {
            ss = rem;
            pp = OFFSET.get(ss);
        } else if (pp >= OFFSET.get(ss + 1)) {
            ss--;
            if (ss == 0) {
                return;
            }
            pp = OFFSET.get(ss);
        }

        assemble(n, t << (2 * ss) | TREE_LIST.get(pp), ss, pp, rem - ss);
        assemble(n, t, ss, pp + 1, rem);
    }

    private static void makeTrees(int n) {
        if (OFFSET.get(n + 1) != 0) {
            return;
        }
        if (n > 0) {
            makeTrees(n - 1);
        }
        assemble(n, 0, n - 1, OFFSET.get(n - 1), n - 1);
        OFFSET.set(n + 1, TREE_LIST.size());
    }

    private static void test(int n) {
        if (n < 1 || n > 12) {
            throw new IllegalArgumentException("Argument must be between 1 and 12");
        }

        append(0);

        makeTrees(n);
        System.out.printf("Number of %d-trees: %d\n", n, OFFSET.get(n + 1) - OFFSET.get(n));
        listTrees(n);
    }

    public static void main(String[] args) {
        test(5);
    }
}

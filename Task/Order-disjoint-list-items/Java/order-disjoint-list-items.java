import java.util.Arrays;
import java.util.BitSet;
import org.apache.commons.lang3.ArrayUtils;

public class OrderDisjointItems {

    public static void main(String[] args) {
        final String[][] MNs = {{"the cat sat on the mat", "mat cat"},
        {"the cat sat on the mat", "cat mat"},
        {"A B C A B C A B C", "C A C A"}, {"A B C A B D A B E", "E A D A"},
        {"A B", "B"}, {"A B", "B A"}, {"A B B A", "B A"}, {"X X Y", "X"}};

        for (String[] a : MNs) {
            String[] r = orderDisjointItems(a[0].split(" "), a[1].split(" "));
            System.out.printf("%s | %s -> %s%n", a[0], a[1], Arrays.toString(r));
        }
    }

    // if input items cannot be null
    static String[] orderDisjointItems(String[] m, String[] n) {
        for (String e : n) {
            int idx = ArrayUtils.indexOf(m, e);
            if (idx != -1)
                m[idx] = null;
        }
        for (int i = 0, j = 0; i < m.length; i++) {
            if (m[i] == null)
                m[i] = n[j++];
        }
        return m;
    }

    // otherwise
    static String[] orderDisjointItems2(String[] m, String[] n) {
        BitSet bitSet = new BitSet(m.length);
        for (String e : n) {
            int idx = -1;
            do {
                idx = ArrayUtils.indexOf(m, e, idx + 1);
            } while (idx != -1 && bitSet.get(idx));
            if (idx != -1)
                bitSet.set(idx);
        }
        for (int i = 0, j = 0; i < m.length; i++) {
            if (bitSet.get(i))
                m[i] = n[j++];
        }
        return m;
    }
}

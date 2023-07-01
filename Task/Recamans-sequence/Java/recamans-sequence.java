import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class RecamanSequence {
    public static void main(String[] args) {
        List<Integer> a = new ArrayList<>();
        a.add(0);

        Set<Integer> used = new HashSet<>();
        used.add(0);

        Set<Integer> used1000 = new HashSet<>();
        used1000.add(0);

        boolean foundDup = false;
        int n = 1;
        while (n <= 15 || !foundDup || used1000.size() < 1001) {
            int next = a.get(n - 1) - n;
            if (next < 1 || used.contains(next)) {
                next += 2 * n;
            }
            boolean alreadyUsed = used.contains(next);
            a.add(next);
            if (!alreadyUsed) {
                used.add(next);
                if (0 <= next && next <= 1000) {
                    used1000.add(next);
                }
            }
            if (n == 14) {
                System.out.printf("The first 15 terms of the Recaman sequence are : %s\n", a);
            }
            if (!foundDup && alreadyUsed) {
                System.out.printf("The first duplicate term is a[%d] = %d\n", n, next);
                foundDup = true;
            }
            if (used1000.size() == 1001) {
                System.out.printf("Terms up to a[%d] are needed to generate 0 to 1000\n", n);
            }
            n++;
        }
    }
}

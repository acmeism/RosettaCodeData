import java.util.HashMap;
import java.util.Map;

public class MutualRecursion {

    public static void main(final String args[]) {
        int max = 20;
        System.out.printf("First %d values of the Female sequence:  %n", max);
        for (int i = 0; i < max; i++) {
            System.out.printf("  f(%d) = %d%n", i, f(i));
        }
        System.out.printf("First %d values of the Male sequence:  %n", max);
        for (int i = 0; i < 20; i++) {
            System.out.printf("  m(%d) = %d%n", i, m(i));
        }
    }

    private static Map<Integer,Integer> F_MAP = new HashMap<>();

    private static int f(final int n) {
        if ( F_MAP.containsKey(n) ) {
            return F_MAP.get(n);
        }
        int fn = n == 0 ? 1 : n - m(f(n - 1));
        F_MAP.put(n, fn);
        return fn;
    }

    private static Map<Integer,Integer> M_MAP = new HashMap<>();

    private static int m(final int n) {
        if ( M_MAP.containsKey(n) ) {
            return M_MAP.get(n);
        }
        int mn = n == 0 ? 0 : n - f(m(n - 1));
        M_MAP.put(n, mn);
        return mn;
    }


}

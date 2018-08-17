import java.util.*;

interface Function<S, T> {
    public T call(S x);
}

public class AlgorithmS {
    private static final Random rand = new Random();
    public static <T> Function<T, List<T>> s_of_n_creator(final int n) {
        return new Function<T, List<T>>() {
            private List<T> sample = new ArrayList<T>(n);
            private int i = 0;
            public List<T> call(T item) {
                if (++i <= n) {
                    sample.add(item);
                } else if (rand.nextInt(i) < n) {
                    sample.set(rand.nextInt(n), item);
                }
                return sample;
            }
        };
    }

    public static void main(String[] args) {
        int[] bin = new int[10];
        for (int trial = 0; trial < 100000; trial++) {
            Function<Integer, List<Integer>> s_of_n = s_of_n_creator(3);
            for (int i = 0; i < 9; i++) s_of_n.call(i);
            for (int s : s_of_n.call(9)) bin[s]++;
        }
        System.out.println(Arrays.toString(bin));
    }
}

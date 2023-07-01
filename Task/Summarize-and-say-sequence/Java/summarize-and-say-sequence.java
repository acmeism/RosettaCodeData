import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.IntStream;

public class SelfReferentialSequence {

    static Map<String, Integer> cache = new ConcurrentHashMap<>(10_000);

    public static void main(String[] args) {
        Seeds res = IntStream.range(0, 1000_000)
                .parallel()
                .mapToObj(n -> summarize(n, false))
                .collect(Seeds::new, Seeds::accept, Seeds::combine);

        System.out.println("Seeds:");
        res.seeds.forEach(e -> System.out.println(Arrays.toString(e)));

        System.out.println("\nSequence:");
        summarize(res.seeds.get(0)[0], true);
    }

    static int[] summarize(int seed, boolean display) {
        String n = String.valueOf(seed);

        String k = Arrays.toString(n.chars().sorted().toArray());
        if (!display && cache.get(k) != null)
            return new int[]{seed, cache.get(k)};

        Set<String> seen = new HashSet<>();
        StringBuilder sb = new StringBuilder();

        int[] freq = new int[10];

        while (!seen.contains(n)) {
            seen.add(n);

            int len = n.length();
            for (int i = 0; i < len; i++)
                freq[n.charAt(i) - '0']++;

            sb.setLength(0);
            for (int i = 9; i >= 0; i--) {
                if (freq[i] != 0) {
                    sb.append(freq[i]).append(i);
                    freq[i] = 0;
                }
            }
            if (display)
                System.out.println(n);
            n = sb.toString();
        }

        cache.put(k, seen.size());

        return new int[]{seed, seen.size()};
    }

    static class Seeds {
        int largest = Integer.MIN_VALUE;
        List<int[]> seeds = new ArrayList<>();

        void accept(int[] s) {
            int size = s[1];
            if (size >= largest) {
                if (size > largest) {
                    largest = size;
                    seeds.clear();
                }
                seeds.add(s);
            }
        }

        void combine(Seeds acc) {
            acc.seeds.forEach(this::accept);
        }
    }
}

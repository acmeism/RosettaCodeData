public class Fibonacci {

    static final Map<Integer, Long> cache = new HashMap<>();
    static {
        cache.put(1, 1L);
        cache.put(2, 1L);
    }

    public static long get(int n)
    {
        return (n < 2) ? n : impl(n);
    }

    private static long impl(int n)
    {
        return cache.computeIfAbsent(n, k -> impl(k-1) + impl(k-2));
    }
}

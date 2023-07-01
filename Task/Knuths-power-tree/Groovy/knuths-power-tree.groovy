class PowerTree {
    private static Map<Integer, Integer> p = new HashMap<>()
    private static List<List<Integer>> lvl = new ArrayList<>()

    static {
        p[1] = 0

        List<Integer> temp = new ArrayList<Integer>()
        temp.add 1
        lvl.add temp
    }

    private static List<Integer> path(int n) {
        if (n == 0) return new ArrayList<Integer>()
        while (!p.containsKey(n)) {
            List<Integer> q = new ArrayList<>()
            for (Integer x in lvl.get(0)) {
                for (Integer y in path(x)) {
                    if (p.containsKey(x + y)) break
                    p[x + y] = x
                    q.add x + y
                }
            }
            lvl[0].clear()
            lvl[0].addAll q
        }
        List<Integer> temp = path p[n]
        temp.add n
        temp
    }

    private static BigDecimal treePow(double x, int n) {
        Map<Integer, BigDecimal> r = new HashMap<>()
        r[0] = BigDecimal.ONE
        r[1] = BigDecimal.valueOf(x)

        int p = 0
        for (Integer i in path(n)) {
            r[i] = r[i - p] * r[p]
            p = i
        }
        r[n]
    }

    private static void showPos(double x, int n, boolean isIntegral) {
        printf("%d: %s\n", n, path(n))
        String f = isIntegral ? "%.0f" : "%f"
        printf(f, x)
        printf(" ^ %d = ", n)
        printf(f, treePow(x, n))
        println()
        println()
    }

    static void main(String[] args) {
        for (int n = 0; n <= 17; ++n) {
            showPos 2.0, n, true
        }
        showPos 1.1, 81, false
        showPos 3.0, 191, true
    }
}

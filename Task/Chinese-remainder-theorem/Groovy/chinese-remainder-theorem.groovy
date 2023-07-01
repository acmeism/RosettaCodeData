class ChineseRemainderTheorem {
    static int chineseRemainder(int[] n, int[] a) {
        int prod = 1
        for (int i = 0; i < n.length; i++) {
            prod *= n[i]
        }

        int p, sm = 0
        for (int i = 0; i < n.length; i++) {
            p = prod.intdiv(n[i])
            sm += a[i] * mulInv(p, n[i]) * p
        }
        return sm % prod
    }

    private static int mulInv(int a, int b) {
        int b0 = b
        int x0 = 0
        int x1 = 1

        if (b == 1) {
            return 1
        }

        while (a > 1) {
            int q = a.intdiv(b)
            int amb = a % b
            a = b
            b = amb
            int xqx = x1 - q * x0
            x1 = x0
            x0 = xqx
        }

        if (x1 < 0) {
            x1 += b0
        }

        return x1
    }

    static void main(String[] args) {
        int[] n = [3, 5, 7]
        int[] a = [2, 3, 2]
        println(chineseRemainder(n, a))
    }
}

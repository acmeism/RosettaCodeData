class MetallicRatios {
    private static List<String> names = new ArrayList<>()
    static {
        names.add("Platinum")
        names.add("Golden")
        names.add("Silver")
        names.add("Bronze")
        names.add("Copper")
        names.add("Nickel")
        names.add("Aluminum")
        names.add("Iron")
        names.add("Tin")
        names.add("Lead")
    }

    private static void lucas(long b) {
        printf("Lucas sequence for %s ratio, where b = %d\n", names[b], b)
        print("First 15 elements: ")
        long x0 = 1
        long x1 = 1
        printf("%d, %d", x0, x1)
        for (int i = 1; i < 13; ++i) {
            long x2 = b * x1 + x0
            printf(", %d", x2)
            x0 = x1
            x1 = x2
        }
        println()
    }

    private static void metallic(long b, int dp) {
        BigInteger x0 = BigInteger.ONE
        BigInteger x1 = BigInteger.ONE
        BigInteger x2
        BigInteger bb = BigInteger.valueOf(b)
        BigDecimal ratio = BigDecimal.ONE.setScale(dp)
        int iters = 0
        String prev = ratio.toString()
        while (true) {
            iters++
            x2 = bb * x1 + x0
            String thiz = (x2.toBigDecimal().setScale(dp) / x1.toBigDecimal().setScale(dp)).toString()
            if (prev == thiz) {
                String plural = "s"
                if (iters == 1) {
                    plural = ""
                }
                printf("Value after %d iteration%s: %s\n\n", iters, plural, thiz)
                return
            }
            prev = thiz
            x0 = x1
            x1 = x2
        }
    }

    static void main(String[] args) {
        for (int b = 0; b < 10; ++b) {
            lucas(b)
            metallic(b, 32)
        }
        println("Golden ratio, where b = 1:")
        metallic(1, 256)
    }
}

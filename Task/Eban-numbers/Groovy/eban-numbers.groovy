class Main {
    private static class Range {
        int start
        int end
        boolean print

        Range(int s, int e, boolean p) {
            start = s
            end = e
            print = p
        }
    }

    static void main(String[] args) {
        List<Range> rgs = Arrays.asList(
                new Range(2, 1000, true),
                new Range(1000, 4000, true),
                new Range(2, 10_000, false),
                new Range(2, 100_000, false),
                new Range(2, 1_000_000, false),
                new Range(2, 10_000_000, false),
                new Range(2, 100_000_000, false),
                new Range(2, 1_000_000_000, false)
        )
        for (Range rg : rgs) {
            if (rg.start == 2) {
                println("eban numbers up to and including $rg.end")
            } else {
                println("eban numbers between $rg.start and $rg.end")
            }
            int count = 0
            for (int i = rg.start; i <= rg.end; ++i) {
                int b = (int) (i / 1_000_000_000)
                int r = i % 1_000_000_000
                int m = (int) (r / 1_000_000)
                r = i % 1_000_000
                int t = (int) (r / 1_000)
                r %= 1_000
                if (m >= 30 && m <= 66) m %= 10
                if (t >= 30 && t <= 66) t %= 10
                if (r >= 30 && r <= 66) r %= 10
                if (b == 0 || b == 2 || b == 4 || b == 6) {
                    if (m == 0 || m == 2 || m == 4 || m == 6) {
                        if (t == 0 || t == 2 || t == 4 || t == 6) {
                            if (r == 0 || r == 2 || r == 4 || r == 6) {
                                if (rg.print) {
                                    print("$i ")
                                }
                                count++
                            }
                        }
                    }
                }
            }
            if (rg.print) {
                println()
            }
            println("count = $count")
            println()
        }
    }
}

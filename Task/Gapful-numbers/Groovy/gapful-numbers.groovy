class GapfulNumbers {
    private static String commatize(long n) {
        StringBuilder sb = new StringBuilder(Long.toString(n))
        int le = sb.length()
        for (int i = le - 3; i >= 1; i -= 3) {
            sb.insert(i, ',')
        }
        return sb.toString()
    }

    static void main(String[] args) {
        List<Long> starts = [(long) 1e2, (long) 1e6, (long) 1e7, (long) 1e9, (long) 7123]
        List<Integer> counts = [30, 15, 15, 10, 25]
        for (int i = 0; i < starts.size(); ++i) {
            println("First ${counts.get(i)} gapful numbers starting at ${commatize(starts.get(i))}")

            long j = starts.get(i)
            long pow = 100
            while (j >= pow * 10) {
                pow *= 10
            }

            int count = 0
            while (count < counts.get(i)) {
                long fl = ((long) (j / pow)) * 10 + (j % 10)
                if (j % fl == 0) {
                    print("$j ")
                    count++
                }
                if (++j >= 10 * pow) {
                    pow *= 10
                }
            }

            println()
            println()
        }
    }
}

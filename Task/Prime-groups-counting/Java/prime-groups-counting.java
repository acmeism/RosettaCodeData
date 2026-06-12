public class Main {

    // Prime check (sqrt optimization vs. Python's naive loop)
    static boolean isPrime(int x) {
        if (x < 2) return false;
        for (int d = 2; d * d <= x; d++) {
            if (x % d == 0) return false;
        }
        return true;
    }

    // Check that for a set of chosen characters, every pairwise abs diff is prime
    static boolean chkGroup(char[] buf, int len) {
        for (int i = 0; i < len; i++) {
            for (int j = i + 1; j < len; j++) {
                int diff = Math.abs(buf[i] - buf[j]);
                if (!isPrime(diff)) return false;
            }
        }
        return true;
    }

    // Count subsets (size >= 2) whose pairwise diffs are all prime
    static int countValidSubsets(String s) {
        char[] a = s.toCharArray();
        int n = a.length;
        int total = 1 << n;
        int count = 0;

        // buffer to avoid rebuilding strings repeatedly
        char[] buf = new char[n];

        for (int mask = 0; mask < total; mask++) {
            int bits = Integer.bitCount(mask);
            if (bits < 2) continue;

            int idx = 0;
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) != 0) {
                    buf[idx++] = a[i];
                }
            }

            if (chkGroup(buf, idx)) {
                count++;
            }
        }
        return count;
    }

    public static void main(String[] args) {
        // Hard-coded test case 1
        String s1 = "abcdef";
        System.out.println("Enter a string: " + s1);
        System.out.println(countValidSubsets(s1));
        System.out.println();

        // Hard-coded test case 2
        String s2 = "abcdefg";
        System.out.println("Enter a string: " + s2);
        System.out.println(countValidSubsets(s2));
    }
}


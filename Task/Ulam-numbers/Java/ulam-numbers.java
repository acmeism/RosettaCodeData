public class UlamNumbers {
    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        for (int n = 1; n <= 100000; n *= 10) {
            System.out.printf("Ulam(%d) = %d\n", n, ulam(n));
        }
        long finish = System.currentTimeMillis();
        System.out.printf("Elapsed time: %.3f seconds\n", (finish - start)/1000.0);
    }

    private static int ulam(int n) {
        int[] ulams = new int[Math.max(n, 2)];
        ulams[0] = 1;
        ulams[1] = 2;
        int sieveLength = 2;
        int[] sieve = new int[sieveLength];
        sieve[0] = sieve[1] = 1;
        for (int u = 2, ulen = 2; ulen < n; ) {
            sieveLength = u + ulams[ulen - 2];
            sieve = extend(sieve, sieveLength);
            for (int i = 0; i < ulen - 1; ++i)
                ++sieve[u + ulams[i] - 1];
            for (int i = u; i < sieveLength; ++i) {
                if (sieve[i] == 1) {
                    u = i + 1;
                    ulams[ulen++] = u;
                    break;
                }
            }
        }
        return ulams[n - 1];
    }

    private static int[] extend(int[] array, int minLength) {
        if (minLength <= array.length)
            return array;
        int newLength = 2 * array.length;
        while (newLength < minLength)
            newLength *= 2;
        int[] newArray = new int[newLength];
        System.arraycopy(array, 0, newArray, 0, array.length);
        return newArray;
    }
}

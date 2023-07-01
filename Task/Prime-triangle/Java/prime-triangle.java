public class PrimeTriangle {
    public static void main(String[] args) {
        long start = System.currentTimeMillis();
        for (int i = 2; i <= 20; ++i) {
            int[] a = new int[i];
            for (int j = 0; j < i; ++j)
                a[j] = j + 1;
            if (findRow(a, 0, i))
                printRow(a);
        }
        System.out.println();
        StringBuilder s = new StringBuilder();
        for (int i = 2; i <= 20; ++i) {
            int[] a = new int[i];
            for (int j = 0; j < i; ++j)
                a[j] = j + 1;
            if (i > 2)
                s.append(" ");
            s.append(countRows(a, 0, i));
        }
        System.out.println(s);
        long finish = System.currentTimeMillis();
        System.out.printf("\nElapsed time: %d milliseconds\n", finish - start);
    }

    private static void printRow(int[] a) {
        for (int i = 0; i < a.length; ++i) {
            if (i != 0)
                System.out.print(" ");
            System.out.printf("%2d", a[i]);
        }
        System.out.println();
    }

    private static boolean findRow(int[] a, int start, int length) {
        if (length == 2)
            return isPrime(a[start] + a[start + 1]);
        for (int i = 1; i + 1 < length; i += 2) {
            if (isPrime(a[start] + a[start + i])) {
                swap(a, start + i, start + 1);
                if (findRow(a, start + 1, length - 1))
                    return true;
                swap(a, start + i, start + 1);
            }
        }
        return false;
    }

    private static int countRows(int[] a, int start, int length) {
        int count = 0;
        if (length == 2) {
            if (isPrime(a[start] + a[start + 1]))
                ++count;
        } else {
            for (int i = 1; i + 1 < length; i += 2) {
                if (isPrime(a[start] + a[start + i])) {
                    swap(a, start + i, start + 1);
                    count += countRows(a, start + 1, length - 1);
                    swap(a, start + i, start + 1);
                }
            }
        }
        return count;
    }

    private static void swap(int[] a, int i, int j) {
        int tmp = a[i];
        a[i] = a[j];
        a[j] = tmp;
    }

    private static boolean isPrime(int n) {
        return ((1L << n) & 0x28208a20a08a28acL) != 0;
    }
}

public class AlmostPrime {
    public static void main(String[] args) {
        for (int k = 1; k <= 5; k++) {
            System.out.print("k = " + k + ":");

            for (int i = 2, c = 0; c < 10; i++) {
                if (kprime(i, k)) {
                    System.out.print(" " + i);
                    c++;
                }
            }

            System.out.println("");
        }
    }

    public static boolean kprime(int n, int k) {
        int f = 0;
        for (int p = 2; f < k && p * p <= n; p++) {
            while (n % p == 0) {
                n /= p;
                f++;
            }
        }
        return f + ((n > 1) ? 1 : 0) == k;
    }
}

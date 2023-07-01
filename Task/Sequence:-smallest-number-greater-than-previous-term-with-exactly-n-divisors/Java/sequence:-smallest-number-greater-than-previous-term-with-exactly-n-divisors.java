public class AntiPrimesPlus {

    static int count_divisors(int n) {
        int count = 0;
        for (int i = 1; i * i <= n; ++i) {
            if (n % i == 0) {
                if (i == n / i)
                    count++;
                else
                    count += 2;
            }
        }
        return count;
    }

    public static void main(String[] args) {
        final int max = 15;
        System.out.printf("The first %d terms of the sequence are:\n", max);
        for (int i = 1, next = 1; next <= max; ++i) {
            if (next == count_divisors(i)) {
                System.out.printf("%d ", i);
                next++;
            }
        }
        System.out.println();
    }
}

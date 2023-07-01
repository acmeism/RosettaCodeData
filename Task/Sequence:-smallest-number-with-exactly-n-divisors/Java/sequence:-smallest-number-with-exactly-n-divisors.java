import java.util.Arrays;

public class OEIS_A005179 {

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
        int[] seq = new int[max];
        System.out.printf("The first %d terms of the sequence are:\n", max);
        for (int i = 1, n = 0; n < max; ++i) {
            int k = count_divisors(i);
            if (k <= max && seq[k - 1] == 0) {
                seq[k- 1] = i;
                n++;
            }
        }
        System.out.println(Arrays.toString(seq));
    }
}

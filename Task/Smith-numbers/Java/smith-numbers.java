import java.util.*;

public class SmithNumbers {

    public static void main(String[] args) {
        for (int n = 1; n < 10_000; n++) {
            List<Integer> factors = primeFactors(n);
            if (factors.size() > 1) {
                int sum = sumDigits(n);
                for (int f : factors)
                    sum -= sumDigits(f);
                if (sum == 0)
                    System.out.println(n);
            }
        }
    }

    static List<Integer> primeFactors(int n) {
        List<Integer> result = new ArrayList<>();

        for (int i = 2; n % i == 0; n /= i)
            result.add(i);

        for (int i = 3; i * i <= n; i += 2) {
            while (n % i == 0) {
                result.add(i);
                n /= i;
            }
        }

        if (n != 1)
            result.add(n);

        return result;
    }

    static int sumDigits(int n) {
        int sum = 0;
        while (n > 0) {
            sum += (n % 10);
            n /= 10;
        }
        return sum;
    }
}

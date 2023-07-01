import java.util.LinkedList;
import java.util.List;

public class LongPrimes
{
    private static void sieve(int limit, List<Integer> primes)
    {
        boolean[] c = new boolean[limit];
        for (int i = 0; i < limit; i++)
            c[i] = false;
        // No need to process even numbers
        int p = 3, n = 0;
        int p2 = p * p;
        while (p2 <= limit)
        {
            for (int i = p2; i <= limit; i += 2 * p)
                c[i] = true;
            do
                p += 2;
            while (c[p]);
            p2 = p * p;
        }
        for (int i = 3; i <= limit; i += 2)
            if (!c[i])
                primes.add(i);
    }

    // Finds the period of the reciprocal of n
    private static int findPeriod(int n)
    {
        int r = 1, period = 0;
        for (int i = 1; i < n; i++)
            r = (10 * r) % n;
        int rr = r;
        do
        {
            r = (10 * r) % n;
            ++period;
        }
        while (r != rr);
        return period;
    }

    public static void main(String[] args)
    {
        int[] numbers = new int[]{500, 1000, 2000, 4000, 8000, 16000, 32000, 64000};
        int[] totals = new int[numbers.length];
        List<Integer> primes = new LinkedList<Integer>();
        List<Integer> longPrimes = new LinkedList<Integer>();
        sieve(64000, primes);
        for (int prime : primes)
            if (findPeriod(prime) == prime - 1)
                longPrimes.add(prime);
        int count = 0, index = 0;
        for (int longPrime : longPrimes)
        {
            if (longPrime > numbers[index])
                totals[index++] = count;
            ++count;
        }
        totals[numbers.length - 1] = count;
        System.out.println("The long primes up to " + numbers[0] + " are:");
        System.out.println(longPrimes.subList(0, totals[0]));
        System.out.println();
        System.out.println("The number of long primes up to:");
        for (int i = 0; i <= 7; i++)
            System.out.printf("  %5d is %d\n", numbers[i], totals[i]);
    }
}

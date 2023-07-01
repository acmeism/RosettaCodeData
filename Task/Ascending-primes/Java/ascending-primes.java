/*
 *  Ascending primes
 *
 *  Generate and show all primes with strictly ascending decimal digits.
 *
 *
 *  Solution
 *
 *  We only consider positive numbers in the range 1 to 123456789. We would
 *  get 7027260 primes, because there are so many primes smaller than 123456789
 *  (see also Wolfram Alpha).On the other hand, there are only 511 distinct
 *  positive integers having their digits arranged in ascending order.
 *  Therefore, it is better to start with numbers that have properly arranged
 *  digits and then check if they are prime numbers.The method of generating
 *  a sequence of such numbers is not indifferent.We want this sequence to be
 *  monotonically increasing, because then additional sorting of results will
 *  be unnecessary. It turns out that by using a queue we can easily get the
 *  desired effect. Additionally, the algorithm then does not use recursion
 *  (although the program probably does not have to comply with the MISRA
 *  standard). The problem to be solved is the queue size, the a priori
 *  assumption that 1000 is good enough, but a bit magical.
 */

package example.rossetacode.ascendingprimes;

import java.util.Arrays;

public class Program implements Runnable {

    public static void main(String[] args) {
        long t1 = System.nanoTime();
        new Program().run();
        long t2 = System.nanoTime();
        System.out.println(
                "total time consumed = " + (t2 - t1) * 1E-6 + " milliseconds");
    }

    public void run() {

        final int MAX_SIZE = 1000;
        final int[] queue = new int[MAX_SIZE];
        int begin = 0;
        int end = 0;

        for (int k = 1; k <= 9; k++) {
            queue[end++] = k;
        }

        while (begin < end) {
            int n = queue[begin++];
            for (int k = n % 10 + 1; k <= 9; k++) {
                queue[end++] = n * 10 + k;
            }
        }

        // We can use a parallel stream (and then sort the results)
        // to use multiple cores.
        //
        System.out.println(Arrays.stream(queue).filter(this::isPrime).boxed().toList());
    }

    private boolean isPrime(int n) {
        if (n == 2) {
            return true;
        }
        if (n == 1 || n % 2 == 0) {
            return false;
        }
        int root = (int) Math.sqrt(n);
        for (int k = 3; k <= root; k += 2) {
            if (n % k == 0) {
                return false;
            }
        }
        return true;
    }
}

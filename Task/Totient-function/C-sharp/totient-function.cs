using static System.Console;
using static System.Linq.Enumerable;

public class Program
{
    static void Main()
    {
        for (int i = 1; i <= 25; i++) {
            int t = Totient(i);
            WriteLine(i + "\t" + t + (t == i - 1 ? "\tprime" : ""));
        }
        WriteLine();
        for (int i = 100; i <= 100_000; i *= 10) {
            WriteLine($"{Range(1, i).Count(x => Totient(x) + 1 == x):n0} primes below {i:n0}");
        }
    }

    static int Totient(int n) {
        if (n < 3) return 1;
        if (n == 3) return 2;

        int totient = n;

        if ((n & 1) == 0) {
            totient >>= 1;
            while (((n >>= 1) & 1) == 0) ;
        }

        for (int i = 3; i * i <= n; i += 2) {
            if (n % i == 0) {
                totient -= totient / i;
                while ((n /= i) % i == 0) ;
            }
        }
        if (n > 1) totient -= totient / n;
        return totient;
    }
}

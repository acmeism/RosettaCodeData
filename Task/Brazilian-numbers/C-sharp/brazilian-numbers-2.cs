using System;

class Program
{
    const           // flags:
    int PrMk = 0,   // a number that is prime
        SqMk = 1,   // a number that is the square of a prime number
        UpMk = 2,   // a number that can be factored (aka un-prime)
        BrMk = -2,  // a prime number that is also a Brazilian number
        Excp = 121; // exception square - the only square prime that is a Brazilian

    static int pow = 9, // power of 10 to count to
        max; // maximum sieve array length
             // An upper limit of the required array length can be calculated like this:
             // power of 10  fraction              limit        actual result
             //   1          2 / 1 * 10          = 20           20
             //   2          4 / 3 * 100         = 133          132
             //   3          6 / 5 * 1000        = 1200         1191
             //   4          8 / 7 * 10000       = 11428        11364
             //   5          10/ 9 * 100000      = 111111       110468
             //   6          12/11 * 1000000     = 1090909      1084566
             //   7          14/13 * 10000000    = 10769230     10708453
             //   8          16/15 * 100000000   = 106666666    106091516
             //   9          18/17 * 1000000000  = 1058823529   1053421821
             // powers above 9 are impractical because of the maximum array length in C#,
             // which is around the UInt32.MaxValue, or 4294967295

    static SByte[] PS; // the prime/Brazilian number sieve
    // once the sieve is populated, primes are <= 0, non-primes are > 0,
    // Brazilian numbers are (< 0) or (> 1)
    // 121 is a special case, in the sieve it is marked with the BrMk (-2)

    // typical sieve of Eratosthenes algorithm
    static void PrimeSieve(int top) {
        PS = new SByte[top]; int i, ii, j;
        i = 2; PS[j = 4] = SqMk; while (j < top - 2) PS[j += 2] = UpMk;
        i = 3; PS[j = 9] = SqMk; while (j < top - 6) PS[j += 6] = UpMk;
        i = 5; while ((ii = i * i) < top) { if (PS[i] == PrMk) {
                j = (top - i) / i; if ((j & 1) == 0) j--;
                do if (PS[j] == PrMk) PS[i * j] = UpMk;
                while ((j -= 2) > i); PS[ii] = SqMk;
            } do ; while (PS[i += 2] != PrMk); }
    }

    // consults the sieve and returns whether a number is Brazilian
    static bool IsBr(int number) { return Math.Abs(PS[number]) > SqMk; }

    // shows the first few Brazilian numbers of several kinds
    static void FirstFew(string kind, int amt) {
        Console.WriteLine("\nThe first {0} {1}Brazilian Numbers are:", amt, kind);
        int i = 7; while (amt > 0) { if (IsBr(i)) { amt--; Console.Write("{0} ", i); }
            switch (kind) {
                case "odd ": i += 2; break;
                case "prime ": do i += 2; while (PS[i] != BrMk || i == Excp); break;
                default: i++; break; } } Console.WriteLine();
    }

    // expands a 111_X number into an integer
    static int Expand(int NumberOfOnes, int Base) {
        int res = 1; while (NumberOfOnes-- > 1) res = res * Base + 1;
        if (res > max || res < 0) res = 0; return res;
    }

    // displays an elapsed time stamp
    static string TS(string fmt, ref DateTime st, bool reset = false) {
        DateTime n = DateTime.Now;
        string res = string.Format(fmt, (n - st).TotalMilliseconds);
        if (reset) st = n; return res;
    }

    static void Main(string[] args) {
        int p2 = pow << 1; DateTime st = DateTime.Now, st0 = st;
        int p10 = (int)Math.Pow(10, pow), p = 10, cnt = 0;
        max = (int)(((long)(p10) * p2) / (p2 - 1)); PrimeSieve(max);
        Console.WriteLine(TS("Sieving took {0} ms", ref st, true));
        int[] primes = new int[7]; // make short list of primes before Brazilians are added
        int n = 3; for (int i = 0; i < primes.Length; i++) { primes[i] = n; do ; while (PS[n += 2] != 0); }
        Console.WriteLine("\nChecking first few prime numbers of sequential ones:\nones checked found");
        // now check the '111_X' style numbers. many are factorable, but some are prime,
        // then re-mark the primes found in the sieve as Brazilian.
        // curiously, only the numbers with a prime number of ones will turn out, so
        // restricting the search to those saves time. no need to wast time on even numbers of ones,
        // or 9 ones, 15 ones, etc...
        foreach(int i in primes) { Console.Write("{0,4}", i); cnt = 0; n = 2;
            do { if ((n - 1) % i != 0) { long br = Expand(i, n);
                    if (br > 0) { if (PS[br] < UpMk) { PS[br] = BrMk; cnt++; } }
                    else { Console.WriteLine("{0,8}{1,6}", n, cnt); break; } }
                n++; } while (true); }
        Console.WriteLine(TS("Adding Brazilian primes to the sieve took {0} ms", ref st, true));
        foreach (string s in ",odd ,prime ".Split(',')) FirstFew(s, 20);
        Console.WriteLine(TS("\nRequired output took {0} ms", ref st, true));
        Console.WriteLine("\nDecade count of Brazilian numbers:");
        n = 6; cnt = 0; do { while (cnt < p) if (IsBr(++n)) cnt++;
            Console.WriteLine("{0,15:n0}th is {1,-15:n0}  {2}", cnt, n, TS("time: {0} ms", ref st));
        } while ((p *= 10) <= p10); PS = new sbyte[0];
        Console.WriteLine("\nTotal elapsed was {0} ms", (DateTime.Now - st0).TotalMilliseconds);
        if (System.Diagnostics.Debugger.IsAttached) Console.ReadKey();
    }
}

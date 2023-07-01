using System;
using System.Linq;
using System.Collections.Generic;

class Program {

    static IEnumerable<long> decline(long min, long max, long stp) {
        long lmt = (min / stp) * stp;
        for (long i = (max / stp) * stp; i >= lmt; i -= stp)
            yield return i;
    }

    static bool ChkDigs(long number) {
        var set = new HashSet<char>();
        return number
            .ToString()
            .All(d => d > '0'
                   && number % (d - '0') == 0
                   && set.Add(d));
    }

    static bool ChkHDigs(long number) {
        const string hDigs = "0123456789abcdef";
        var set = new HashSet<char>();
        return number
            .ToString("x")
            .All(d => d > '0'
                   && number % hDigs.IndexOf(d) == 0
                   && set.Add(d));
    }

    static void Main() {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        long min = 1236798,  // lowest possible seven digit number
            max = 9876312,   // high limit
            stp = 9 * 8 * 7, // skip numbers without this factor
            result = decline(min, max, stp)
                .Where(ChkDigs)
                .First();
        sw.Stop();
        Console.Write("Base 10 = {0} in {1} ms", result,
            sw.Elapsed.TotalMilliseconds);
        sw.Restart();
        min = 0x123456789abcdef; // lowest possible 15 digit number
        max = 0xfedcba987654321; // high limit
        stp = 15*14*13*12*11;    // skip numbers without this factor
        result = decline(min, max, stp)
                .Where(ChkHDigs)
                .First();
        sw.Stop();
        Console.Write("\nBase 16 = {0} in {1} sec",
            result.ToString("x"), sw.Elapsed.TotalSeconds);
    }
}

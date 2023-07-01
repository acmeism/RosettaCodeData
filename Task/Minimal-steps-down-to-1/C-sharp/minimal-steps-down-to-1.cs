using System;
using System.Collections.Generic;
using System.Linq;

public static class MinimalSteps
{
    public static void Main() {
        var (divisors, subtractors) = (new int[] { 2, 3 }, new [] { 1 });
        var lookup = CreateLookup(2_000, divisors, subtractors);
        Console.WriteLine($"Divisors: [{divisors.Delimit()}], Subtractors: [{subtractors.Delimit()}]");
        PrintRange(lookup, 10);
        PrintMaxMins(lookup);
        lookup = CreateLookup(20_000, divisors, subtractors);
        PrintMaxMins(lookup);
        Console.WriteLine();

        subtractors = new [] { 2 };
        lookup = CreateLookup(2_000, divisors, subtractors);
        Console.WriteLine($"Divisors: [{divisors.Delimit()}], Subtractors: [{subtractors.Delimit()}]");
        PrintRange(lookup, 10);
        PrintMaxMins(lookup);
        lookup = CreateLookup(20_000, divisors, subtractors);
        PrintMaxMins(lookup);
    }

    private static void PrintRange((char op, int param, int steps)[] lookup, int limit) {
        for (int goal = 1; goal <= limit; goal++) {
            var x = lookup[goal];
            if (x.param == 0) {
                Console.WriteLine($"{goal} cannot be reached with these numbers.");
                continue;
            }
            Console.Write($"{goal} takes {x.steps} {(x.steps == 1 ? "step" : "steps")}: ");
            for (int n = goal; n > 1; ) {
                Console.Write($"{n},{x.op}{x.param}=> ");
                n = x.op == '/' ? n / x.param : n - x.param;
                x = lookup[n];
            }
            Console.WriteLine("1");
        }
    }

    private static void PrintMaxMins((char op, int param, int steps)[] lookup) {
        var maxSteps = lookup.Max(x => x.steps);
        var items = lookup.Select((x, i) => (i, x)).Where(t => t.x.steps == maxSteps).ToList();
        Console.WriteLine(items.Count == 1
            ? $"There is one number below {lookup.Length-1} that requires {maxSteps} steps: {items[0].i}"
            : $"There are {items.Count} numbers below {lookup.Length-1} that require {maxSteps} steps: {items.Select(t => t.i).Delimit()}"
        );
    }

    private static (char op, int param, int steps)[] CreateLookup(int goal, int[] divisors, int[] subtractors)
    {
        var lookup = new (char op, int param, int steps)[goal+1];
        lookup[1] = ('/', 1, 0);
        for (int n = 1; n < lookup.Length; n++) {
            var ln = lookup[n];
            if (ln.param == 0) continue;
            for (int d = 0; d < divisors.Length; d++) {
                int target = n * divisors[d];
                if (target > goal) break;
                if (lookup[target].steps == 0 || lookup[target].steps > ln.steps) lookup[target] = ('/', divisors[d], ln.steps + 1);
            }
            for (int s = 0; s < subtractors.Length; s++) {
                int target = n + subtractors[s];
                if (target > goal) break;
                if (lookup[target].steps == 0 || lookup[target].steps > ln.steps) lookup[target] = ('-', subtractors[s], ln.steps + 1);
            }
        }
        return lookup;
    }

    private static string Delimit<T>(this IEnumerable<T> source) => string.Join(", ", source);
}

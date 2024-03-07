using System;
using System.Collections.Generic;
using System.Linq;

public class Test
{
    static void DistCheck(Func<int> func, int nRepeats, double delta)
    {
        var counts = new Dictionary<int, int>();

        for (int i = 0; i < nRepeats; i++)
        {
            int result = func();
            if (counts.ContainsKey(result))
                counts[result]++;
            else
                counts[result] = 1;
        }

        double target = nRepeats / (double)counts.Count;
        int deltaCount = (int)(delta / 100.0 * target);

        foreach (var kvp in counts)
        {
            if (Math.Abs(target - kvp.Value) >= deltaCount)
                Console.WriteLine("distribution potentially skewed for '{0}': '{1}'", kvp.Key, kvp.Value);
        }

        foreach (var key in counts.Keys.OrderBy(k => k))
        {
            Console.WriteLine("{0} {1}", key, counts[key]);
        }
    }

    public static void Main(string[] args)
    {
        DistCheck(() => new Random().Next(1, 6), 1_000_000, 1);
    }
}

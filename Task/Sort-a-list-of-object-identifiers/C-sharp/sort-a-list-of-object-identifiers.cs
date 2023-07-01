using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    public static void Main() {
        var oids = new [] {
            "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
            "1.3.6.1.4.1.11.2.17.5.2.0.79",
            "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
            "1.3.6.1.4.1.11150.3.4.0.1",
            "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
            "1.3.6.1.4.1.11150.3.4.0"
        };

        var comparer = Comparer<string>.Create((a, b) => {
            int c = a.Split('.').Select(int.Parse)
	        .Zip(b.Split('.').Select(int.Parse),
                    (i, j) => i.CompareTo(j)).FirstOrDefault(x => x != 0);
            return c != 0 ? c : a.Length.CompareTo(b.Length);
        });

        Array.Sort(oids, comparer);

        Console.WriteLine(string.Join(Environment.NewLine, oids));
    }
}

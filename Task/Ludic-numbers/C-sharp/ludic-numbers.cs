using System;
using System.Linq;
using System.Collections.Generic;

public class Program
{
    public static void Main()
    {
        Console.WriteLine("First 25 ludic numbers:");
        Console.WriteLine(string.Join(", ", LudicNumbers(150).Take(25)));
        Console.WriteLine();

        Console.WriteLine($"There are {LudicNumbers(1001).Count()} ludic numbers below 1000");
        Console.WriteLine();

        foreach (var ludic in LudicNumbers(22000).Skip(1999).Take(6)
                .Select((n, i) => $"#{i+2000} = {n}")) {
            Console.WriteLine(ludic);
        }
        Console.WriteLine();

        Console.WriteLine("Triplets below 250:");
        var queue = new Queue<int>(5);
        foreach (int x in LudicNumbers(255)) {
            if (queue.Count == 5) queue.Dequeue();
            queue.Enqueue(x);
            if (x - 6 < 250 && queue.Contains(x - 6) && queue.Contains(x - 4)) {
                Console.WriteLine($"{x-6}, {x-4}, {x}");
            }
        }
    }

    public static IEnumerable<int> LudicNumbers(int limit) {
        yield return 1;
        //Like a linked list, but with value types.
        //Create 2 extra entries at the start to avoid ugly index calculations
        //and another at the end to avoid checking for index-out-of-bounds.
        Entry[] values = Enumerable.Range(0, limit + 1).Select(n => new Entry(n)).ToArray();
        for (int i = 2; i < limit; i = values[i].Next) {
            yield return values[i].N;
            int start = i;
            while (start < limit) {
                Unlink(values, start);
                for (int step = 0; step < i && start < limit; step++)
                    start = values[start].Next;
            }
        }
    }

    static void Unlink(Entry[] values, int index) {
        values[values[index].Prev].Next = values[index].Next;
        values[values[index].Next].Prev = values[index].Prev;
    }

}

struct Entry
{
    public Entry(int n) : this() {
        N = n;
        Prev = n - 1;
        Next = n + 1;
    }

    public int N { get; }
    public int Prev { get; set; }
    public int Next { get; set; }
}

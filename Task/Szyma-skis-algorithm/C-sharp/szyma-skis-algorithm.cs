using System;
using System.Collections.Concurrent;
using System.Linq;
using System.Threading;

class Program
{
    private static ConcurrentDictionary<int, int> dict = new ConcurrentDictionary<int, int>();
    private static int criticalValue = 1;
    private static readonly object lockObject = new object();

    static void Main(string[] args)
    {
        TestSzymanski(20);
    }

    static int Flag(int id)
    {
        return dict.GetOrAdd(id, 0);
    }

    static void RunSzymanski(int id, int[] allszy)
    {
        var others = allszy.Where(t => t != id).ToArray();
        dict[id] = 1; // Standing outside waiting room
        while (others.Any(t => Flag(t) >= 3))
        {
            Thread.Yield();
        }
        dict[id] = 3; // Standing in doorway
        if (others.Any(t => Flag(t) == 1))
        {
            dict[id] = 2; // Waiting for other processes to enter
            while (!others.Any(t => Flag(t) == 4))
            {
                Thread.Yield();
            }
        }
        dict[id] = 4; // The door is closed
        foreach (var t in others)
        {
            if (t >= id) continue;
            while (Flag(t) > 1)
            {
                Thread.Yield();
            }
        }

        // critical section
        lock (lockObject)
        {
            criticalValue += id * 3;
            criticalValue /= 2;
            Console.WriteLine($"Thread {id} changed the critical value to {criticalValue}.");
        }
        // end critical section

        // Exit protocol
        foreach (var t in others)
        {
            if (t <= id) continue;
            while (!new[] { 0, 1, 4 }.Contains(Flag(t)))
            {
                Thread.Yield();
            }
        }
        dict[id] = 0; // Leave. Reopen door if nobody is still in the waiting room
    }

    static void TestSzymanski(int N)
    {
        int[] allszy = Enumerable.Range(1, N).ToArray();
        var threads = allszy.Select(i => new Thread(() => RunSzymanski(i, allszy))).ToArray();

        foreach (var thread in threads)
        {
            thread.Start();
        }

        foreach (var thread in threads)
        {
            thread.Join();
        }
    }
}

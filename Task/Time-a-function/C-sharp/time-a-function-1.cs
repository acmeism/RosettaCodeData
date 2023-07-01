using System;
using System.Linq;
using System.Threading;
using System.Diagnostics;

class Program {
    static void Main(string[] args) {
        Stopwatch sw = new Stopwatch();

        sw.Start();
        DoSomething();
        sw.Stop();

        Console.WriteLine("DoSomething() took {0}ms.", sw.Elapsed.TotalMilliseconds);
    }

    static void DoSomething() {
        Thread.Sleep(1000);

        Enumerable.Range(1, 10000).Where(x => x % 2 == 0).Sum();  // Sum even numers from 1 to 10000
    }
}

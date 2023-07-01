using System;
using System.Linq;
using System.Threading;

class Program {
    static void Main(string[] args) {
        DateTime start, end;

        start = DateTime.Now;
        DoSomething();
        end = DateTime.Now;

        Console.WriteLine("DoSomething() took " + (end - start).TotalMilliseconds + "ms");
    }

    static void DoSomething() {
        Thread.Sleep(1000);

        Enumerable.Range(1, 10000).Where(x => x % 2 == 0).Sum();  // Sum even numers from 1 to 10000
    }
}

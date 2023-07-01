using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

class Program
{
    static void ThreadStart(object item)
    {
        Thread.Sleep(1000 * (int)item);
        Console.WriteLine(item);
    }

    static void SleepSort(IEnumerable<int> items)
    {
        foreach (var item in items)
        {
            new Thread(ThreadStart).Start(item);
        }
    }

    static void Main(string[] arguments)
    {
        SleepSort(arguments.Select(int.Parse));
    }
}

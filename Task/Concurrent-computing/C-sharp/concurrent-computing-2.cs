using System;
using System.Threading.Tasks;

public class Program
{
    static async Task Main() {
        Task t1 = Task.Run(() => Console.WriteLine("Enjoy"));
        Task t2 = Task.Run(() => Console.WriteLine("Rosetta"));
        Task t3 = Task.Run(() => Console.WriteLine("Code"));

        await Task.WhenAll(t1, t2, t3);
    }
}

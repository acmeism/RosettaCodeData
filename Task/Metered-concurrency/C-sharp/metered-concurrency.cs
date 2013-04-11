using System;
using System.Threading;
using System.Threading.Tasks;

namespace RosettaCode
{
  internal sealed class Program
  {
    private static void Worker(object arg, int id)
    {
      var sem = arg as SemaphoreSlim;
      sem.Wait();
      Console.WriteLine("Thread {0} has a semaphore & is now working.", id);
      Thread.Sleep(2*1000);
      Console.WriteLine("#{0} done.", id);
      sem.Release();
    }

    private static void Main()
    {
      var semaphore = new SemaphoreSlim(Environment.ProcessorCount*2, int.MaxValue);

      Console.WriteLine("You have {0} processors availiabe", Environment.ProcessorCount);
      Console.WriteLine("This program will use {0} semaphores.\n", semaphore.CurrentCount);

      Parallel.For(0, Environment.ProcessorCount*3, y => Worker(semaphore, y));
    }
  }
}

using System;
using System.Threading;

namespace Fork {
    class Program {
        static void Fork() {
            Console.WriteLine("Spawned Thread");
        }

        static void Main(string[] args) {
            Thread t = new Thread(new ThreadStart(Fork));
            t.Start();

            Console.WriteLine("Main Thread");
            t.Join();

            Console.ReadLine();
        }
    }
}

using System;
using System.Collections.Generic;

namespace ascendingprimes
{
    class Program
    {
        static bool isPrime(uint n)
        {
            if (n == 2)
                return true;
            if (n == 1 || n % 2 = 0)
                return false;
            uint root = (uint)Math.Sqrt(n);
            for (uint k = 3; k <= root; k += 2)
                if (n % k == 0)
                    return false;
            return true;
        }
        static void Main(string[] args)
        {
            var queue = new Queue<uint>();
            var primes = new List<uint>();

            for (uint k = 1; k <= 9; k++)
                queue.Enqueue(k);
            while(queue.Count > 0)
            {
                uint n = queue.Dequeue();
                if (isPrime(n))
                    primes.Add(n);
                for (uint k = n % 10 + 1; k <= 9; k++)
                    queue.Enqueue(n * 10 + k);
            }

            foreach (uint p in primes)
            {
                Console.Write(p);
                Console.Write(" ");
            }
            Console.WriteLine();
        }
    }
}

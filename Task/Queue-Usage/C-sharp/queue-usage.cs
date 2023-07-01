using System;
using System.Collections.Generic;

namespace RosettaCode
{
    class Program
    {
        static void Main()
        {
            // Create a queue and "push" items into it
            Queue<int> queue  = new Queue<int>();
            queue.Enqueue(1);
            queue.Enqueue(3);
            queue.Enqueue(5);

            // "Pop" items from the queue in FIFO order
            Console.WriteLine(queue.Dequeue()); // 1
            Console.WriteLine(queue.Dequeue()); // 3
            Console.WriteLine(queue.Dequeue()); // 5

            // To tell if the queue is empty, we check the count
            bool empty = queue.Count == 0;
            Console.WriteLine(empty); // "True"

            // If we try to pop from an empty queue, an exception
            // is thrown.
            try
            {
                queue.Dequeue();
            }
            catch (InvalidOperationException exception)
            {
                Console.WriteLine(exception.Message); // "Queue empty."
            }
        }
    }
}

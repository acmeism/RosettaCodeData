using System;
using System.Collections.Generic;

namespace PriorityQueueExample
{
	class Program
	{
		static void Main(string[] args)
		{
			// Starting with .NET 6.0 preview 2 (released March 11th, 2021), there's a built-in priority queue
			var p = new PriorityQueue<string, int>();
			p.Enqueue("Clear drains", 3);
			p.Enqueue("Feed cat", 4);
			p.Enqueue("Make tea", 5);
			p.Enqueue("Solve RC tasks", 1);
			p.Enqueue("Tax return", 2);
			while (p.TryDequeue(out string task, out int priority))
			{
				Console.WriteLine($"{priority}\t{task}");
			}
		}
	}
}

/* Output:

1       Solve RC tasks
2       Tax return
3       Clear drains
4       Feed cat
5       Make tea

 */

using System.Diagnostics;


// Methods that return values and don't modify the object

int[] arr = [1, 2, 3, 4, 5];
arr.Reverse();
Console.WriteLine(string.Join(", ", arr));


// Tasks are not threads! There are not 50 threads here even though there are 50 tasks.
// See https://blog.stephencleary.com/2013/11/there-is-no-thread.html

Console.WriteLine(Process.GetCurrentProcess().Threads.Count);
Task[] tasks = [.. Enumerable.Range(0, 50).Select(i => Task.Delay(1000))];
Console.WriteLine(Process.GetCurrentProcess().Threads.Count);
Task.WaitAll(tasks);
Console.WriteLine(Process.GetCurrentProcess().Threads.Count);

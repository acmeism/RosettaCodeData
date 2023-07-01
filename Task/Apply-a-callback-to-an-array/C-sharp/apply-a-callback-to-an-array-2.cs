using System;

static class Program
{
  // Purpose: Apply a callback (or anonymous method) to an Array
  // Output: Prints the squares of an int array to the console.
  // Compiler: Visual Studio 2005
  // Framework: .net 2

  [STAThread]
  public static void Main()
  {
    int[] intArray = { 1, 2, 3, 4, 5 };

    // Using a callback,
    Console.WriteLine("Printing squares using a callback:");
    Array.ForEach<int>(intArray, PrintSquare);

    // or using an anonymous method:
    Console.WriteLine("Printing squares using an anonymous method:");
    Array.ForEach<int>
    (
      intArray,
      delegate(int value)
      {
        Console.WriteLine(value * value);
      });
  }

  public static void PrintSquare(int value)
  {
    Console.WriteLine(value * value);
  }
}

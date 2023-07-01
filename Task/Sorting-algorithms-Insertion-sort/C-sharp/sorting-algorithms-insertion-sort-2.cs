  using Sort;
  using System;

  class Program {
    static void Main(String[] args) {
      var entries = new Int32[] { 3, 9, 4, 6, 8, 1, 7, 2, 5 };
      InsertionSort<Int32>.Sort(entries);
      Console.WriteLine(String.Join(" ", entries));
    }
  }

  using Sort;
  using System;

  class Program {
    static void Main(String[] args) {
      var entries = new Int32[] { 1, 3, 5, 7, 9, 8, 6, 4, 2 };
      var sorter = new QuickSort<Int32>();
      sorter.Sort(entries);
      Console.WriteLine(String.Join(" ", entries));
    }
  }

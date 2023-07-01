  using Sort;
  using System;

  class Program {
    static void Main(String[] args) {
      var entries = new Int32[] { 7, 5, 2, 6, 1, 4, 2, 6, 3 };
      var sorter = new MergeSort<Int32>();
      sorter.Sort(entries);
      Console.WriteLine(String.Join(" ", entries));
    }
  }

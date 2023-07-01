//#define UseRecursiveSearch

using System;
using Search;

class Program {
  static readonly int[][] tests = {
    new int[] { },
    new int[] { 2 },
    new int[] { 2, 2 },
    new int[] { 2, 2, 2, 2 },
    new int[] { 3, 3, 4, 4 },
    new int[] { 0, 1, 3, 3, 4, 4 },
    new int[] { 0, 1, 2, 2, 2, 3, 3, 4, 4},
    new int[] { 0, 1, 1, 2, 2, 2, 3, 3, 4, 4 },
    new int[] { 0, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4 },
    new int[] { 0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 4 },
    new int[] { 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 4, 4 },
  };

  static void Main(string[] args) {
    var index = 0;
    foreach (var test in tests) {
      var join = String.Join(" ", test);
      Console.WriteLine($"test[{index}]: {join}");
#if UseRecursiveSearch
      var glb = test.RecursiveBinarySearchForGLB(2);
      var lub = test.RecursiveBinarySearchForLUB(2);
#else
      var glb = test.BinarySearchForGLB(2);
      var lub = test.BinarySearchForLUB(2);
#endif
      Console.WriteLine($"glb = {glb}");
      Console.WriteLine($"lub = {lub}");

      index++;
    }
#if DEBUG
    Console.Write("Press Enter");
    Console.ReadLine();
#endif
  }
}

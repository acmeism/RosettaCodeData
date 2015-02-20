using System;
using System.Collections.Generic;

class RandomElementPicker {
  static void Main() {
    var list = new List<int>(new[]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9});
    var rng = new Random();
    var randomElement = list[rng.Next(list.Count)];
    Console.WriteLine("I picked element {0}", randomElement);
  }
}

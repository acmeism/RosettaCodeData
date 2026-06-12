class Program {

  static void Main(string[] args) { int[] lst; int sum;
    var w = new System.Collections.Generic.List<(int digs, int sum)> {};
    foreach (int x in lst = new int[] { 2, 3, 5, 7 } ) w.Add((x, x));
    while (w.Count > 0) { var i = w[0]; w.RemoveAt(0);
      foreach (var j in lst) if ((sum = i.sum + j) == 13)
          System.Console.Write ("{0}{1} ", i.digs, j);
        else if (sum < 12)
          w.Add((i.digs * 10 + j, sum)); } }
}

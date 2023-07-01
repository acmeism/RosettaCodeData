using System.Linq;

static class Program
{
  static void Main()
  {
    var ts =
      from a in Enumerable.Range(1, 20)
      from b in Enumerable.Range(a, 21 - a)
      from c in Enumerable.Range(b, 21 - b)
      where a * a + b * b == c * c
      select new { a, b, c };

      foreach (var t in ts)
        System.Console.WriteLine("{0}, {1}, {2}", t.a, t.b, t.c);
  }
}

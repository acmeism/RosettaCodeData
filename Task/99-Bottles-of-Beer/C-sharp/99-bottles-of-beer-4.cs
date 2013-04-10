using System;
using System.Linq;

class Program
{
    static void Main()
    {
        BeerBottles().Take(99).ToList().ForEach(Console.WriteLine);	
    }

    static IEnumerable<String> BeerBottles()
    {
        int i = 100;
        String f = "{0}, {1}. Take one down, pass it around, {2}";
        Func<int, bool, String> booze = (c , b) =>
            String.Format("{0} bottle{1} of beer{2}", c > 0 ? c.ToString() : "no more", (c == 1 ? "" : "s"), b ? " on the wall" : "");
	
        while (--i >= 1)
            yield return String.Format(f, booze(i, true), booze(i, false), booze(i - 1, true));
    }
}

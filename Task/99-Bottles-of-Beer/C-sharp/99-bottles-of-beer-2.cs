using System;
using System.Linq;

class Program
{
    static void Main()
    {
        var query = from total in Enumerable.Range(0,100).Reverse()
                    select (total > 0)
                        ? string.Format("{0} bottles of beer on the wall\n{0} bottles of beer\nTake one down, pass it around", total)
                        : string.Format("{0} bottles left", total);

        foreach (var item in query)
        {
            Console.WriteLine(item);
        }
    }
}

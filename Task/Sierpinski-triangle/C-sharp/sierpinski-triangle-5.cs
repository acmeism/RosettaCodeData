using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static List<string> Sierpinski(int n)
    {
	return Enumerable.Range(0, n).Aggregate(
	   new List<string>(){"*"},
	     (p, i) => {
		string SPACE = " ".PadRight((int)Math.Pow(2, i));

		var temp =  new List<string>(from x in p select SPACE + x + SPACE);
		temp.AddRange(from x in p select x + " " + x);

		return temp;
	     }
	);
    }

    static void Main ()
    {
	foreach(string s in Sierpinski(4)) { Console.WriteLine(s); }
    }
}

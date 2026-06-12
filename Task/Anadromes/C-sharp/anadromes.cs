using System;
using System.Linq;

class Programm
{
    static void Main()
    {
        var words = File.ReadAllLines("words.txt").Where(s => s.Length > 6).ToHashSet();

        foreach (string w in words) {
            var w_rev = new string(w.Reverse().ToArray());
            if (words.Contains(w_rev) && w.CompareTo(w_rev) < 0)
                Console.WriteLine("{0, -12}{1, -12}", w, w_rev);
        }
    }
}

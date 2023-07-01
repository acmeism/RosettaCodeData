using System;
using System.Collections.Generic;
using System.Linq;

static class Module1
{
    static Random r = new Random();

    static List<int> getThree(int n)
    {
        List<int> g3 = new List<int>();
        for (int i = 0; i < 4; i++) g3.Add(r.Next(n) + 1);
        g3.Sort(); g3.RemoveAt(0); return g3;
    }

    static List<int> getSix()
    {
        List<int> g6 = new List<int>();
        for (int i = 0; i < 6; i++) g6.Add(getThree(6).Sum());
        return g6;
    }

    static void Main(string[] args)
    {
        bool good = false; do {
            List<int> gs = getSix(); int gss = gs.Sum(); int hvc = gs.FindAll(x => x > 14).Count;
            Console.Write("attribs: {0}, sum={1}, ({2} sum, high vals={3})",
                          string.Join(", ", gs), gss, gss >= 75 ? "good" : "low", hvc);
            Console.WriteLine(" - {0}", (good = gs.Sum() >= 75 && hvc > 1) ? "success" : "failure");
        } while (!good);
    }
}

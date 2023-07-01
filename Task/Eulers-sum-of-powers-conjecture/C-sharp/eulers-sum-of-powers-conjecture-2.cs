using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Euler_cs
{
    class Program
    {
        struct Pair
        {
            public int a, b;
            public Pair(int x, int y)
            {
                a = x; b = y;
            }
        }

        static int min = 1, max = 250;
        static ulong[] p5;
        static SortedDictionary<ulong, Pair>[] sum2 =
                   new SortedDictionary<ulong, Pair>[30];

        static string Fmt(Pair p)
        {
            return string.Format("{0}^5 + {1}^5", p.a, p.b);
        }

        public static void InitM()
        {
            for (int i = 0; i <= 29; i++)
                sum2[i] = new SortedDictionary<ulong, Pair>();
            p5 = new ulong[max + 1];
            p5[min] = Convert.ToUInt64(min) * Convert.ToUInt64(min);
            p5[min] *= p5[min] * Convert.ToUInt64(min);
            for (int i = min; i <= max - 1; i++)
            {
                for (int j = i + 1; j <= max; j++)
                {
                    p5[j] = Convert.ToUInt64(j) * Convert.ToUInt64(j);
                    p5[j] *= p5[j] * Convert.ToUInt64(j);
                    if (j == max) continue;
                    ulong x = p5[i] + p5[j];
                    sum2[x % 30].Add(x, new Pair(i, j));
                }
            }
        }

        static List<string> CalcM(int m)
        {
            List<string> res = new List<string>();
            for (int i = max; i >= min; i--)
            {
                ulong p = p5[i]; int pm = i % 30, mp = (pm - m + 30) % 30;
                foreach (var s in sum2[m].Keys)
                {
                    if (p <= s) break;
                    ulong t = p - s;
                    if (sum2[mp].Keys.Contains(t) && sum2[mp][t].a > sum2[m][s].b)
                        res.Add(string.Format("  {1} + {2} = {0}^5",
                            i, Fmt(sum2[m][s]), Fmt(sum2[mp][t])));
                }
            }
            return res;
        }

        static int Snip(string s)
        {
            int p = s.IndexOf("=") + 1;
            return Convert.ToInt32(s.Substring(p, s.IndexOf("^", p) - p));
        }

        static int CompareRes(string x, string y)
        {
            int res = Snip(x).CompareTo(Snip(y));
            if (res == 0) res = x.CompareTo(y);
            return res;
        }

        static int Validify(int def, string s)
        {
            int res = def, t = 0; int.TryParse(s, out t);
            if (t >= 1 && t < Math.Pow((double)(ulong.MaxValue >> 1), 0.2))
                res = t;
            return res;
        }

        static void Switch(ref int a, ref int b)
        {
            int t = a; a = b; b = t;
        }

        static void Main(string[] args)
        {
            if (args.Count() > 1)
            {
                min = Validify(min, args[0]);
                max = Validify(max, args[1]);
                if (max < min) Switch(ref max, ref min);
            }
            else if (args.Count() == 1)
                max = Validify(max, args[0]);
            Console.WriteLine("Mod 30 shortcut with threading, checking from {0} to {1}...", min, max);
            List<string> res = new List<string>();
            DateTime st = DateTime.Now;
            List<Task<List<string>>> taskList = new List<Task<List<string>>>();
            InitM();
            for (int j = 0; j <= 29; j++)
            {
                var jj = j;
                taskList.Add(Task.Run(() => CalcM(jj)));
            }
            Task.WhenAll(taskList);
            foreach (var item in taskList.Select(t => t.Result))
                res.AddRange(item);
            res.Sort(CompareRes);
            foreach (var item in res)
                Console.WriteLine(item);
            Console.WriteLine("  Computation time to check entire space was {0} seconds",
                (DateTime.Now - st).TotalSeconds);
            if (System.Diagnostics.Debugger.IsAttached)
                Console.ReadKey();
        }
    }
}

using System.Collections.Generic; using System.Linq; using static System.Console;

class Program {

    static bool soas(int n, IEnumerable<int> f) {
        if (n <= 0) return false; if (f.Contains(n)) return true;
        switch(n.CompareTo(f.Sum())) { case 1: return false; case 0: return true;
            case -1: var rf = f.Reverse().ToList(); var d = n - rf[0]; rf.RemoveAt(0);
                return soas(d, rf) || soas(n, rf); } return true; }

    static bool ip(int n) { var f = Enumerable.Range(1, n >> 1).Where(d => n % d == 0).ToList();
        return Enumerable.Range(1, n - 1).ToList().TrueForAll(i => soas(i, f));  }

    static void Main() {
        int c = 0, m = 333; for (int i = 1; i <= m; i += i == 1 ? 1 : 2)
            if (ip(i) || i == 1) Write("{0,3} {1}", i, ++c % 10 == 0 ? "\n" : "");
        Write("\nFound {0} practical numbers between 1 and {1} inclusive.\n", c, m);
        do Write("\n{0,5} is a{1}practical number.",
            m = m < 500 ? m << 1 : m * 10 + 6, ip(m) ? " " : "n im"); while (m < 1e4); } }

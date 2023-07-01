using System.Linq; class Program { static void Main() {
    int a, b, c, d, e, f, g; int[] h = new int[g = 1000];
    for (a = 0, b = 1, c = 2; c < g; a = b, b = c++)
        for (d = a, e = b - d, f = h[b]; e <= b; e++)
            if (f == h[d--]) { h[c] = e; break; }
    void sho(int i) { System.Console.WriteLine(string.Join(" ",
        h.Skip(i).Take(10))); } sho(0); sho(990); } }

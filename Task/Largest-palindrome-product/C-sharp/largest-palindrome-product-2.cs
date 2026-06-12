using System;

class Program {

    static bool isPal(long n) {
        long rev = 0, lr = -1, rem;
        while (n > rev) {
            n = Math.DivRem(n, 10, out rem);
            if (lr < 0 && rem == 0) return false;
            lr = rev; rev = 10 * rev + rem;
            if (n == rev || n == lr) return true;
        } return false; }

    static void doOne(int n) {
        int ld, c; string bs = "";
        string sx = "9" + new string('0', (n - 1) << 1) + "9", sm = new string('9', n);
        long x = long.Parse(sx), y = (long)Math.Sqrt(x), oy, max = long.Parse(sm), max9 = max - 9, z, yy, p, bp = x;
        var a = new long[] { 0, 9, 0, 3, 0, 0, 0, 7, 0, 1 };
        y /= 11;
        if ((y & 1) == 0) y--;
        if (y % 5 == 0) y -= 2;
        y *= 11; oy = y;
        while (y <= max) y += 22; y -= 22;
        while (y >= oy) {
            c = 0;
            yy = y * 10;
            z = max9 + a[ld = (int)(y % 10)];
            //Console.WriteLine("y,z: {0},{1}", y, z);
            p = y * z;
            while (p >= bp) {
                if (isPal(p)) {
                    if (p > bp) bp = p;
                    bs = string.Format(" {0,2} {1,10} x {2,-10} = {3}{4}", n, y, z - c, new string(' ', 10 - n), bp); }
                p -= yy; c += 10; }
            y -= ld == 7 ? 44 : 22; }
        Console.WriteLine(bs); }

    static void Main(string[] args) {
        Console.WriteLine("digs    factor   factor            palindrome");
        var sw = System.Diagnostics.Stopwatch.StartNew();
        for (int i = 2, h = 1; i <= 10; h = ++i >> 1) {
            if ((i & 1) == 0) {
                string b = new string('9', i),
                       a = new string('9', h) + new string('0', (h) - 1) + "1",
                       c = new string('9', h) + new string('0', i) + new string('9', h);
                Console.WriteLine(" {0,2} {1,10} x {2,-10} = {3}{4}", i, a, b, new string(' ', 10 - i), c); }
            else doOne(i);
        }
        sw.Stop();
        Console.Write("{0} sec", sw.Elapsed.TotalSeconds);
    }
}

using System;

class Program {
    static int gcd(int a, int b) { return b > 0 ? gcd(b, a % b) : a; }

    // returns least common multiple of digits of x in base b
    static int lcmd(long x, int b) {
      int r = (int)(x % b), a; x /= b; while (x > 0) {
        r = (r * (a = (int)(x % b))) / gcd(r, a); x /= b; } return r; }

    static void Main(string[] args) {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        long mx = 987654321; // all digits except zero
             mx = 98764321; // omitting 5 because even numbers are lost
             mx /= 10;     // 7 digs because 8 digs won't divide by 3
        long skip = lcmd(mx, 10), i; bool nDup;
        for (i = mx - mx % skip; ; i -= skip) {
            var s = i.ToString().ToCharArray(); Array.Sort(s);
            if (s[0] == '0') continue; // no zeros
            nDup = true; // checking for duplicate digits or digit five
            for (int j = 0, k = 1; k < s.Length; j = k++)
                if (s[j] == s[k] || s[k] == '5') { nDup = false; break; }
            if (nDup) break; } sw.Stop(); // found it
        Console.Write("base 10 = {0} in {1} μs\n", i,
          1000 * sw.Elapsed.TotalMilliseconds);
        sw.Restart();
        mx = 0xfedcba987654321;    // all 15 digits used, no zero
        skip = lcmd(mx >> 4, 16); // digit one implied, so omit it
        for (i = mx - mx % skip; ; i -= skip) {
            var s = i.ToString("x").ToCharArray(); Array.Sort(s);
            if (s[0] == '0') continue; // no zeros
            nDup = true; // checking for duplicate digits
            for (int j = 0, k = 1; k < s.Length; j = k++)
                if (s[j] == s[k]) { nDup = false; break; }
            if (nDup) break; } sw.Stop(); // found it
        Console.Write("base 16 = {0} in {1} ms", i.ToString("x"),
          sw.Elapsed.TotalMilliseconds); } }

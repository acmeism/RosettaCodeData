using System;
class Program {

  static bool isPal(int n) {
    int rev = 0, lr = -1, rem;
    while (n > rev) {
      n = Math.DivRem(n, 10, out rem);
      if (lr < 0 && rem == 0) return false;
      lr = rev; rev = 10 * rev + rem;
      if (n == rev || n == lr) return true;
    } return false; }

  static void Main(string[] args) {
    var sw = System.Diagnostics.Stopwatch.StartNew();
    int x = 900009, y = (int)Math.Sqrt(x), y10, max = 999, max9 = max - 9, z, p, bp = x, ld, c;
    var a = new int[]{ 0,9,0,3,0,0,0,7,0,1 }; string bs = "";
    y /= 11;
    if ((y & 1) == 0) y--;
    if (y % 5 == 0) y -= 2;
    y *= 11;
    while (y <= max) {
      c = 0;
      y10 = y * 10;
      z = max9 + a[ld = y % 10];
      p = y * z;
      while (p >= bp) {
        if (isPal(p)) {
          if (p > bp) bp = p;
          bs = string.Format("{0} x {1} = {2}", y, z - c, bp);
        }
        p -= y10; c += 10;
      }
      y += ld == 3 ? 44 : 22;
    }
    sw.Stop();
    Console.Write("{0} {1} μs", bs, sw.Elapsed.TotalMilliseconds * 1000.0);
  }
}

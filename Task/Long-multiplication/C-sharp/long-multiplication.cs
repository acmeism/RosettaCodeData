using System;
using static System.Console;
using BI = System.Numerics.BigInteger;

class Program {

  static decimal mx = 1E28M, hm = 1E14M, a;

  // allows for 56 digit representation, using 28 decimal digits from each decimal
  struct bi { public decimal hi, lo; }

  // sets up for squaring process
  static bi set4sq(decimal a) { bi r; r.hi = Math.Floor(a / hm); r.lo = a % hm; return r; }

  // outputs bi structure as string, optionally inserting commas
  static string toStr(bi a, bool comma = false) {
    string r = a.hi == 0 ? string.Format("{0:0}", a.lo) :
                           string.Format("{0:0}{1:" + new string('0', 28) + "}", a.hi, a.lo);
    if (!comma) return r;  string rc = "";
    for (int i = r.Length - 3; i > 0; i -= 3) rc = "," + r.Substring(i, 3) + rc;
    return r.Substring(0, ((r.Length + 2) % 3) + 1) + rc; }

  // needed because Math.Pow() returns a double
  static decimal Pow_dec(decimal bas, uint exp) {
    if (exp == 0) return 1M; decimal tmp = Pow_dec(bas, exp >> 1); tmp *= tmp;
    if ((exp & 1) == 0) return tmp; return tmp * bas; }

  static void Main(string[] args) {
    for (uint p = 64; p < 95; p += 30) {        // show prescribed output and maximum power of 2 output
      bi x = set4sq(a = Pow_dec(2M, p)), y;     // setup for squaring process
      WriteLine("The square of (2^{0}):                    {1,38:n0}", p, a); BI BS = BI.Pow((BI)a, 2);
      y.lo = x.lo * x.lo; y.hi = x.hi * x.hi;   // square lo and hi parts
      a = x.hi * x.lo * 2M;                     // calculate midterm
      y.hi += Math.Floor(a / hm);               // increment hi part w/ high part of midterm
      y.lo += (a % hm) * hm;                    // increment lo part w/ low part of midterm
      while (y.lo > mx) { y.lo -= mx; y.hi++; } // check for overflow, adjust both parts as needed
      WriteLine(" is {0,75} (which {1} match the BigInteger computation)\n", toStr(y, true),
          BS.ToString() == toStr(y) ? "does" : "fails to"); } }

}

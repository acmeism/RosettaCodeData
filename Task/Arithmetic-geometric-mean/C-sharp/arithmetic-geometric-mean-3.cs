using static System.Math;
using static System.Console;
using BI = System.Numerics.BigInteger;

class Program {

    static BI BIP(char leadDig, int numDigs) { // makes big constant
        return BI.Parse(leadDig + new string('0', numDigs)); }

    static BI IntSqRoot(BI v, BI res) { // res is the initial guess
        BI term = 0, d = 0, dl = 1; while (dl != d) { term = v / res; res = (res + term) >> 1;
            dl = d; d = term - res; } return term; }

    static BI CalcByAGM(int digs) { // note: a and b are hard-coded for this RC task
        BI a = BIP('1', digs), // value of 1, extended to required number of digits
            b = BI.Parse(string.Format("{0:0.00000000000000000}", Sqrt(0.5)).Substring(2) +
                new string('0', digs - 17)), // initial guess for square root of 0.5
            c, // temporary variable to swap a and b
            diff = 0, ldiff = 1; // difference of a and b, last difference
        b = IntSqRoot(BIP('5', (digs << 1) - 1), b); // value of square root of 0.5
        while (ldiff != diff) { ldiff = diff; c = a; a = (a + b) >> 1;
            diff = a - (b = IntSqRoot(c * b, a)); } return b; }

    static void Main(string[] args) {
        int digits = 25000; if (args.Length > 0) {
            int.TryParse(args[0], out digits);
            if (digits < 1 || digits > 999999) digits = 25000; }
        WriteLine("0.{0}", CalcByAGM(digits));
        if (System.Diagnostics.Debugger.IsAttached) ReadKey(); }
}

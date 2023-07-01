using static System.Math;
using static System.Console;
using BI = System.Numerics.BigInteger;

class Program {

    static BI IntSqRoot(BI v, BI res) { // res is the initial guess
        BI term = 0, d = 0, dl = 1; while (dl != d) { term = v / res; res = (res + term) >> 1;
            dl = d; d = term - res; } return term; }

    static string doOne(int b, int digs) { // calculates result via square root, not iterations
        int s = b * b + 4; BI g = (BI)(Sqrt((double)s) * Pow(10, ++digs)),
            bs = IntSqRoot(s * BI.Parse('1' + new string('0', digs << 1)), g);
        bs += b * BI.Parse('1' + new string('0', digs));
        bs >>= 1; bs += 4; string st = bs.ToString();
        return string.Format("{0}.{1}", st[0], st.Substring(1, --digs)); }

    static string divIt(BI a, BI b, int digs) { // performs division
        int al = a.ToString().Length, bl = b.ToString().Length;
        a *= BI.Pow(10, ++digs << 1); b *= BI.Pow(10, digs);
        string s = (a / b + 5).ToString(); return s[0] + "." + s.Substring(1, --digs); }

    // custom formating
    static string joined(BI[] x) { int[] wids = {1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};
        string res = ""; for (int i = 0; i < x.Length; i++) res +=
            string.Format("{0," + (-wids[i]).ToString() + "} ", x[i]); return res; }

    static void Main(string[] args) { // calculates and checks each "metal"
        WriteLine("Metal B Sq.Rt Iters /---- 32 decimal place value ----\\  Matches Sq.Rt Calc");
        int k; string lt, t = ""; BI n, nm1, on; for (int b = 0; b < 10; b++) {
            BI[] lst = new BI[15]; lst[0] = lst[1] = 1;
            for (int i = 2; i < 15; i++) lst[i] = b * lst[i - 1] + lst[i - 2];
            // since all the iterations (except Pt) are > 15, continue iterating from the end of the list of 15
            n = lst[14]; nm1 = lst[13]; k = 0; for (int j = 13; k == 0; j++) {
                lt = t; if (lt == (t = divIt(n, nm1, 32))) k = b == 0 ? 1 : j;
                on = n; n = b * n + nm1; nm1 = on; }
            WriteLine("{0,4}  {1}   {2,2}    {3, 2}  {4}  {5}\n{6,19} {7}", "Pt Au Ag CuSn Cu Ni Al Fe Sn Pb"
                .Split(' ')[b], b, b * b + 4, k, t, t == doOne(b, 32), "", joined(lst)); }
        // now calculate and check big one
        n = nm1 =1; k = 0; for (int j = 1; k == 0; j++) {
            lt = t; if (lt == (t = divIt(n, nm1, 256))) k = j;
                on = n; n += nm1; nm1 = on; }
        WriteLine("\nAu to 256 digits:"); WriteLine(t);
        WriteLine("Iteration count: {0}  Matched Sq.Rt Calc: {1}", k, t == doOne(1, 256)); }
}

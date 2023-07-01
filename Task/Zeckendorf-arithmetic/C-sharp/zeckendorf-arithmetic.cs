using System;
using System.Text;

namespace ZeckendorfArithmetic {
    class Zeckendorf : IComparable<Zeckendorf> {
        private static readonly string[] dig = { "00", "01", "10" };
        private static readonly string[] dig1 = { "", "1", "10" };

        private int dVal = 0;
        private int dLen = 0;

        public Zeckendorf() : this("0") {
            // empty
        }

        public Zeckendorf(string x) {
            int q = 1;
            int i = x.Length - 1;
            dLen = i / 2;
            while (i >= 0) {
                dVal += (x[i] - '0') * q;
                q *= 2;
                i--;
            }
        }

        private void A(int n) {
            int i = n;
            while (true) {
                if (dLen < i) dLen = i;
                int j = (dVal >> (i * 2)) & 3;
                switch (j) {
                    case 0:
                    case 1:
                        return;
                    case 2:
                        if (((dVal >> ((i + 1) * 2)) & 1) != 1) return;
                        dVal += 1 << (i * 2 + 1);
                        return;
                    case 3:
                        int temp = 3 << (i * 2);
                        temp ^= -1;
                        dVal = dVal & temp;
                        B((i + 1) * 2);
                        break;
                }
                i++;
            }
        }

        private void B(int pos) {
            if (pos == 0) {
                Inc();
                return;
            }
            if (((dVal >> pos) & 1) == 0) {
                dVal += 1 << pos;
                A(pos / 2);
                if (pos > 1) A(pos / 2 - 1);
            }
            else {
                int temp = 1 << pos;
                temp ^= -1;
                dVal = dVal & temp;
                B(pos + 1);
                B(pos - (pos > 1 ? 2 : 1));
            }
        }

        private void C(int pos) {
            if (((dVal >> pos) & 1) == 1) {
                int temp = 1 << pos;
                temp ^= -1;
                dVal = dVal & temp;
                return;
            }
            C(pos + 1);
            if (pos > 0) {
                B(pos - 1);
            }
            else {
                Inc();
            }
        }

        public Zeckendorf Inc() {
            dVal++;
            A(0);
            return this;
        }

        public Zeckendorf Copy() {
            Zeckendorf z = new Zeckendorf {
                dVal = dVal,
                dLen = dLen
            };
            return z;
        }

        public void PlusAssign(Zeckendorf other) {
            for (int gn = 0; gn < (other.dLen + 1) * 2; gn++) {
                if (((other.dVal >> gn) & 1) == 1) {
                    B(gn);
                }
            }
        }

        public void MinusAssign(Zeckendorf other) {
            for (int gn = 0; gn < (other.dLen + 1) * 2; gn++) {
                if (((other.dVal >> gn) & 1) == 1) {
                    C(gn);
                }
            }
            while ((((dVal >> dLen * 2) & 3) == 0) || (dLen == 0)) {
                dLen--;
            }
        }

        public void TimesAssign(Zeckendorf other) {
            Zeckendorf na = other.Copy();
            Zeckendorf nb = other.Copy();
            Zeckendorf nt;
            Zeckendorf nr = new Zeckendorf();
            for (int i = 0; i < (dLen + 1) * 2; i++) {
                if (((dVal >> i) & 1) > 0) {
                    nr.PlusAssign(nb);
                }
                nt = nb.Copy();
                nb.PlusAssign(na);
                na = nt.Copy();
            }
            dVal = nr.dVal;
            dLen = nr.dLen;
        }

        public int CompareTo(Zeckendorf other) {
            return dVal.CompareTo(other.dVal);
        }

        public override string ToString() {
            if (dVal == 0) {
                return "0";
            }

            int idx = (dVal >> (dLen * 2)) & 3;
            StringBuilder sb = new StringBuilder(dig1[idx]);
            for (int i = dLen - 1; i >= 0; i--) {
                idx = (dVal >> (i * 2)) & 3;
                sb.Append(dig[idx]);
            }
            return sb.ToString();
        }
    }

    class Program {
        static void Main(string[] args) {
            Console.WriteLine("Addition:");
            Zeckendorf g = new Zeckendorf("10");
            g.PlusAssign(new Zeckendorf("10"));
            Console.WriteLine(g);
            g.PlusAssign(new Zeckendorf("10"));
            Console.WriteLine(g);
            g.PlusAssign(new Zeckendorf("1001"));
            Console.WriteLine(g);
            g.PlusAssign(new Zeckendorf("1000"));
            Console.WriteLine(g);
            g.PlusAssign(new Zeckendorf("10101"));
            Console.WriteLine(g);
            Console.WriteLine();

            Console.WriteLine("Subtraction:");
            g = new Zeckendorf("1000");
            g.MinusAssign(new Zeckendorf("101"));
            Console.WriteLine(g);
            g = new Zeckendorf("10101010");
            g.MinusAssign(new Zeckendorf("1010101"));
            Console.WriteLine(g);
            Console.WriteLine();

            Console.WriteLine("Multiplication:");
            g = new Zeckendorf("1001");
            g.TimesAssign(new Zeckendorf("101"));
            Console.WriteLine(g);
            g = new Zeckendorf("101010");
            g.PlusAssign(new Zeckendorf("101"));
            Console.WriteLine(g);
        }
    }
}

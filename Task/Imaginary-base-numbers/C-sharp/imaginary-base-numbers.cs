using System;
using System.Linq;
using System.Text;

namespace ImaginaryBaseNumbers {
    class Complex {
        private double real, imag;

        public Complex(int r, int i) {
            real = r;
            imag = i;
        }

        public Complex(double r, double i) {
            real = r;
            imag = i;
        }

        public static Complex operator -(Complex self) =>
            new Complex(-self.real, -self.imag);

        public static Complex operator +(Complex rhs, Complex lhs) =>
            new Complex(rhs.real + lhs.real, rhs.imag + lhs.imag);

        public static Complex operator -(Complex rhs, Complex lhs) =>
            new Complex(rhs.real - lhs.real, rhs.imag - lhs.imag);

        public static Complex operator *(Complex rhs, Complex lhs) =>
            new Complex(
                rhs.real * lhs.real - rhs.imag * lhs.imag,
                rhs.real * lhs.imag + rhs.imag * lhs.real
                );

        public static Complex operator *(Complex rhs, double lhs) =>
             new Complex(rhs.real * lhs, rhs.imag * lhs);

        public static Complex operator /(Complex rhs, Complex lhs) =>
            rhs * lhs.Inv();

        public Complex Inv() {
            double denom = real * real + imag * imag;
            return new Complex(real / denom, -imag / denom);
        }

        public QuaterImaginary ToQuaterImaginary() {
            if (real == 0.0 && imag == 0.0) return new QuaterImaginary("0");
            int re = (int)real;
            int im = (int)imag;
            int fi = -1;
            StringBuilder sb = new StringBuilder();
            while (re != 0) {
                int rem = re % -4;
                re /= -4;
                if (rem < 0) {
                    rem = 4 + rem;
                    re++;
                }
                sb.Append(rem);
                sb.Append(0);
            }
            if (im != 0) {
                double f = (new Complex(0.0, imag) / new Complex(0.0, 2.0)).real;
                im = (int)Math.Ceiling(f);
                f = -4.0 * (f - im);
                int index = 1;
                while (im != 0) {
                    int rem = im % -4;
                    im /= -4;
                    if (rem < 0) {
                        rem = 4 + rem;
                        im++;
                    }
                    if (index < sb.Length) {
                        sb[index] = (char)(rem + 48);
                    } else {
                        sb.Append(0);
                        sb.Append(rem);
                    }
                    index += 2;
                }
                fi = (int)f;
            }
            string reverse = new string(sb.ToString().Reverse().ToArray());
            sb.Length = 0;
            sb.Append(reverse);
            if (fi != -1) sb.AppendFormat(".{0}", fi);
            string s = sb.ToString().TrimStart('0');
            if (s[0] == '.') s = "0" + s;
            return new QuaterImaginary(s);
        }

        public override string ToString() {
            double real2 = (real == -0.0) ? 0.0 : real;  // get rid of negative zero
            double imag2 = (imag == -0.0) ? 0.0 : imag;  // ditto
            if (imag2 == 0.0) {
                return string.Format("{0}", real2);
            }
            if (real2 == 0.0) {
                return string.Format("{0}i", imag2);
            }
            if (imag2 > 0.0) {
                return string.Format("{0} + {1}i", real2, imag2);
            }
            return string.Format("{0} - {1}i", real2, -imag2);
        }
    }

    class QuaterImaginary {
        internal static Complex twoI = new Complex(0.0, 2.0);
        internal static Complex invTwoI = twoI.Inv();

        private string b2i;

        public QuaterImaginary(string b2i) {
            if (b2i == "" || !b2i.All(c => "0123.".IndexOf(c) > -1) || b2i.Count(c => c == '.') > 1) {
                throw new Exception("Invalid Base 2i number");
            }
            this.b2i = b2i;
        }

        public Complex ToComplex() {
            int pointPos = b2i.IndexOf(".");
            int posLen = (pointPos != -1) ? pointPos : b2i.Length;
            Complex sum = new Complex(0.0, 0.0);
            Complex prod = new Complex(1.0, 0.0);
            for (int j = 0; j < posLen; j++) {
                double k = (b2i[posLen - 1 - j] - '0');
                if (k > 0.0) {
                    sum += prod * k;
                }
                prod *= twoI;
            }
            if (pointPos != -1) {
                prod = invTwoI;
                for (int j = posLen + 1; j < b2i.Length; j++) {
                    double k = (b2i[j] - '0');
                    if (k > 0.0) {
                        sum += prod * k;
                    }
                    prod *= invTwoI;
                }
            }

            return sum;
        }

        public override string ToString() {
            return b2i;
        }
    }

    class Program {
        static void Main(string[] args) {
            for (int i = 1; i <= 16; i++) {
                Complex c1 = new Complex(i, 0);
                QuaterImaginary qi = c1.ToQuaterImaginary();
                Complex c2 = qi.ToComplex();
                Console.Write("{0,4} -> {1,8} -> {2,4}     ", c1, qi, c2);
                c1 = -c1;
                qi = c1.ToQuaterImaginary();
                c2 = qi.ToComplex();
                Console.WriteLine("{0,4} -> {1,8} -> {2,4}", c1, qi, c2);
            }
            Console.WriteLine();
            for (int i = 1; i <= 16; i++) {
                Complex c1 = new Complex(0, i);
                QuaterImaginary qi = c1.ToQuaterImaginary();
                Complex c2 = qi.ToComplex();
                Console.Write("{0,4} -> {1,8} -> {2,4}     ", c1, qi, c2);
                c1 = -c1;
                qi = c1.ToQuaterImaginary();
                c2 = qi.ToComplex();
                Console.WriteLine("{0,4} -> {1,8} -> {2,4}", c1, qi, c2);
            }
        }
    }
}

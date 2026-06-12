using System;
using System.Text;

namespace GeometricAlgebra {
    struct Vector {
        private readonly double[] dims;

        public Vector(double[] da) {
            dims = da;
        }

        public static Vector operator -(Vector v) {
            return v * -1.0;
        }

        public static Vector operator +(Vector lhs, Vector rhs) {
            var result = new double[32];
            Array.Copy(lhs.dims, 0, result, 0, lhs.Length);
            for (int i = 0; i < result.Length; i++) {
                result[i] = lhs[i] + rhs[i];
            }
            return new Vector(result);
        }

        public static Vector operator *(Vector lhs, Vector rhs) {
            var result = new double[32];
            for (int i = 0; i < lhs.Length; i++) {
                if (lhs[i] != 0.0) {
                    for (int j = 0; j < lhs.Length; j++) {
                        if (rhs[j] != 0.0) {
                            var s = ReorderingSign(i, j) * lhs[i] * rhs[j];
                            var k = i ^ j;
                            result[k] += s;//there is an index out of bounds here
                        }
                    }
                }
            }
            return new Vector(result);
        }

        public static Vector operator *(Vector v, double scale) {
            var result = (double[])v.dims.Clone();
            for (int i = 0; i < result.Length; i++) {
                result[i] *= scale;
            }
            return new Vector(result);
        }

        public double this[int key] {
            get {
                return dims[key];
            }

            set {
                dims[key] = value;
            }
        }

        public int Length {
            get {
                return dims.Length;
            }
        }

        public Vector Dot(Vector rhs) {
            return (this * rhs + rhs * this) * 0.5;
        }

        private static int BitCount(int i) {
            i -= ((i >> 1) & 0x55555555);
            i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
            i = (i + (i >> 4)) & 0x0F0F0F0F;
            i += (i >> 8);
            i += (i >> 16);
            return i & 0x0000003F;
        }

        private static double ReorderingSign(int i, int j) {
            int k = i >> 1;
            int sum = 0;
            while (k != 0) {
                sum += BitCount(k & j);
                k >>= 1;
            }
            return ((sum & 1) == 0) ? 1.0 : -1.0;
        }

        public override string ToString() {
            var it = dims.GetEnumerator();

            StringBuilder sb = new StringBuilder("[");
            if (it.MoveNext()) {
                sb.Append(it.Current);
            }
            while (it.MoveNext()) {
                sb.Append(", ");
                sb.Append(it.Current);
            }

            sb.Append(']');
            return sb.ToString();
        }
    }

    class Program {
        static double[] DoubleArray(uint size) {
            double[] result = new double[size];
            for (int i = 0; i < size; i++) {
                result[i] = 0.0;
            }
            return result;
        }

        static Vector E(int n) {
            if (n > 4) {
                throw new ArgumentException("n must be less than 5");
            }

            var result = new Vector(DoubleArray(32));
            result[1 << n] = 1.0;
            return result;
        }

        static readonly Random r = new Random();

        static Vector RandomVector() {
            var result = new Vector(DoubleArray(32));
            for (int i = 0; i < 5; i++) {
                var singleton = new double[] { r.NextDouble() };
                result += new Vector(singleton) * E(i);
            }
            return result;
        }

        static Vector RandomMultiVector() {
            var result = new Vector(DoubleArray(32));
            for (int i = 0; i < result.Length; i++) {
                result[i] = r.NextDouble();
            }
            return result;
        }

        static void Main() {
            for (int i = 0; i < 5; i++) {
                for (int j = 0; j < 5; j++) {
                    if (i < j) {
                        if (E(i).Dot(E(j))[0] != 0.0) {
                            Console.WriteLine("Unexpected non-null sclar product.");
                            return;
                        }
                    } else if (i == j) {
                        if ((E(i).Dot(E(j)))[0] == 0.0) {
                            Console.WriteLine("Unexpected null sclar product.");
                        }
                    }
                }
            }

            var a = RandomMultiVector();
            var b = RandomMultiVector();
            var c = RandomMultiVector();
            var x = RandomVector();

            // (ab)c == a(bc)
            Console.WriteLine((a * b) * c);
            Console.WriteLine(a * (b * c));
            Console.WriteLine();

            // a(b+c) == ab + ac
            Console.WriteLine(a * (b + c));
            Console.WriteLine(a * b + a * c);
            Console.WriteLine();

            // (a+b)c == ac + bc
            Console.WriteLine((a + b) * c);
            Console.WriteLine(a * c + b * c);
            Console.WriteLine();

            // x^2 is real
            Console.WriteLine(x * x);
        }
    }
}

import java.util.Arrays;
import java.util.Random;

public class GeometricAlgebra {
    private static int bitCount(int i) {
        i -= ((i >> 1) & 0x55555555);
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);
        i = (i + (i >> 4)) & 0x0F0F0F0F;
        i += (i >> 8);
        i += (i >> 16);
        return i & 0x0000003F;
    }

    private static double reorderingSign(int i, int j) {
        int k = i >> 1;
        int sum = 0;
        while (k != 0) {
            sum += bitCount(k & j);
            k = k >> 1;
        }
        return ((sum & 1) == 0) ? 1.0 : -1.0;
    }

    static class Vector {
        private double[] dims;

        public Vector(double[] dims) {
            this.dims = dims;
        }

        public Vector dot(Vector rhs) {
            return times(rhs).plus(rhs.times(this)).times(0.5);
        }

        public Vector unaryMinus() {
            return times(-1.0);
        }

        public Vector plus(Vector rhs) {
            double[] result = Arrays.copyOf(dims, 32);
            for (int i = 0; i < rhs.dims.length; ++i) {
                result[i] += rhs.get(i);
            }
            return new Vector(result);
        }

        public Vector times(Vector rhs) {
            double[] result = new double[32];
            for (int i = 0; i < dims.length; ++i) {
                if (dims[i] != 0.0) {
                    for (int j = 0; j < rhs.dims.length; ++j) {
                        if (rhs.get(j) != 0.0) {
                            double s = reorderingSign(i, j) * dims[i] * rhs.dims[j];
                            int k = i ^ j;
                            result[k] += s;
                        }
                    }
                }
            }
            return new Vector(result);
        }

        public Vector times(double scale) {
            double[] result = dims.clone();
            for (int i = 0; i < 5; ++i) {
                dims[i] *= scale;
            }
            return new Vector(result);
        }

        double get(int index) {
            return dims[index];
        }

        void set(int index, double value) {
            dims[index] = value;
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder("(");
            boolean first = true;
            for (double value : dims) {
                if (first) {
                    first = false;
                } else {
                    sb.append(", ");
                }
                sb.append(value);
            }
            return sb.append(")").toString();
        }
    }

    private static Vector e(int n) {
        if (n > 4) {
            throw new IllegalArgumentException("n must be less than 5");
        }
        Vector result = new Vector(new double[32]);
        result.set(1 << n, 1.0);
        return result;
    }

    private static final Random rand = new Random();

    private static Vector randomVector() {
        Vector result = new Vector(new double[32]);
        for (int i = 0; i < 5; ++i) {
            Vector temp = new Vector(new double[]{rand.nextDouble()});
            result = result.plus(temp.times(e(i)));
        }
        return result;
    }

    private static Vector randomMultiVector() {
        Vector result = new Vector(new double[32]);
        for (int i = 0; i < 32; ++i) {
            result.set(i, rand.nextDouble());
        }
        return result;
    }

    public static void main(String[] args) {
        for (int i = 0; i < 5; ++i) {
            for (int j = 0; j < 5; ++j) {
                if (i < j) {
                    if (e(i).dot(e(j)).get(0) != 0.0) {
                        System.out.println("Unexpected non-null scalar product.");
                        return;
                    }
                }
            }
        }

        Vector a = randomMultiVector();
        Vector b = randomMultiVector();
        Vector c = randomMultiVector();
        Vector x = randomVector();

        // (ab)c == a(bc)
        System.out.println(a.times(b).times(c));
        System.out.println(a.times(b.times(c)));
        System.out.println();

        // a(b+c) == ab + ac
        System.out.println(a.times(b.plus(c)));
        System.out.println(a.times(b).plus(a.times(c)));
        System.out.println();

        // (a+b)c == ac + bc
        System.out.println(a.plus(b).times(c));
        System.out.println(a.times(c).plus(b.times(c)));
        System.out.println();

        // x^2 is real
        System.out.println(x.times(x));
    }
}

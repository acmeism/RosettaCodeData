import java.util.Arrays;

public class PolynomialLongDivision {
    private static class Solution {
        double[] quotient, remainder;

        Solution(double[] q, double[] r) {
            this.quotient = q;
            this.remainder = r;
        }
    }

    private static int polyDegree(double[] p) {
        for (int i = p.length - 1; i >= 0; --i) {
            if (p[i] != 0.0) return i;
        }
        return Integer.MIN_VALUE;
    }

    private static double[] polyShiftRight(double[] p, int places) {
        if (places <= 0) return p;
        int pd = polyDegree(p);
        if (pd + places >= p.length) {
            throw new IllegalArgumentException("The number of places to be shifted is too large");
        }
        double[] d = Arrays.copyOf(p, p.length);
        for (int i = pd; i >= 0; --i) {
            d[i + places] = d[i];
            d[i] = 0.0;
        }
        return d;
    }

    private static void polyMultiply(double[] p, double m) {
        for (int i = 0; i < p.length; ++i) {
            p[i] *= m;
        }
    }

    private static void polySubtract(double[] p, double[] s) {
        for (int i = 0; i < p.length; ++i) {
            p[i] -= s[i];
        }
    }

    private static Solution polyLongDiv(double[] n, double[] d) {
        if (n.length != d.length) {
            throw new IllegalArgumentException("Numerator and denominator vectors must have the same size");
        }
        int nd = polyDegree(n);
        int dd = polyDegree(d);
        if (dd < 0) {
            throw new IllegalArgumentException("Divisor must have at least one one-zero coefficient");
        }
        if (nd < dd) {
            throw new IllegalArgumentException("The degree of the divisor cannot exceed that of the numerator");
        }
        double[] n2 = Arrays.copyOf(n, n.length);
        double[] q = new double[n.length];
        while (nd >= dd) {
            double[] d2 = polyShiftRight(d, nd - dd);
            q[nd - dd] = n2[nd] / d2[nd];
            polyMultiply(d2, q[nd - dd]);
            polySubtract(n2, d2);
            nd = polyDegree(n2);
        }
        return new Solution(q, n2);
    }

    private static void polyShow(double[] p) {
        int pd = polyDegree(p);
        for (int i = pd; i >= 0; --i) {
            double coeff = p[i];
            if (coeff == 0.0) continue;
            if (coeff == 1.0) {
                if (i < pd) {
                    System.out.print(" + ");
                }
            } else if (coeff == -1.0) {
                if (i < pd) {
                    System.out.print(" - ");
                } else {
                    System.out.print("-");
                }
            } else if (coeff < 0.0) {
                if (i < pd) {
                    System.out.printf(" - %.1f", -coeff);
                } else {
                    System.out.print(coeff);
                }
            } else {
                if (i < pd) {
                    System.out.printf(" + %.1f", coeff);
                } else {
                    System.out.print(coeff);
                }
            }
            if (i > 1) System.out.printf("x^%d", i);
            else if (i == 1) System.out.print("x");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        double[] n = new double[]{-42.0, 0.0, -12.0, 1.0};
        double[] d = new double[]{-3.0, 1.0, 0.0, 0.0};
        System.out.print("Numerator   : ");
        polyShow(n);
        System.out.print("Denominator : ");
        polyShow(d);
        System.out.println("-------------------------------------");
        Solution sol = polyLongDiv(n, d);
        System.out.print("Quotient    : ");
        polyShow(sol.quotient);
        System.out.print("Remainder   : ");
        polyShow(sol.remainder);
    }
}

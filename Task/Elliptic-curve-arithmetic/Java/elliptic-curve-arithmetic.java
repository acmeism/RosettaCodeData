import static java.lang.Math.*;
import java.util.Locale;

public class Test {

    public static void main(String[] args) {
        Pt a = Pt.fromY(1);
        Pt b = Pt.fromY(2);
        System.out.printf("a = %s%n", a);
        System.out.printf("b = %s%n", b);
        Pt c = a.plus(b);
        System.out.printf("c = a + b = %s%n", c);
        Pt d = c.neg();
        System.out.printf("d = -c = %s%n", d);
        System.out.printf("c + d = %s%n", c.plus(d));
        System.out.printf("a + b + d = %s%n", a.plus(b).plus(d));
        System.out.printf("a * 12345 = %s%n", a.mult(12345));
    }
}

class Pt {
    final static int bCoeff = 7;

    double x, y;

    Pt(double x, double y) {
        this.x = x;
        this.y = y;
    }

    static Pt zero() {
        return new Pt(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY);
    }

    boolean isZero() {
        return this.x > 1e20 || this.x < -1e20;
    }

    static Pt fromY(double y) {
        return new Pt(cbrt(pow(y, 2) - bCoeff), y);
    }

    Pt dbl() {
        if (isZero())
            return this;
        double L = (3 * this.x * this.x) / (2 * this.y);
        double x2 = pow(L, 2) - 2 * this.x;
        return new Pt(x2, L * (this.x - x2) - this.y);
    }

    Pt neg() {
        return new Pt(this.x, -this.y);
    }

    Pt plus(Pt q) {
        if (this.x == q.x && this.y == q.y)
            return dbl();

        if (isZero())
            return q;

        if (q.isZero())
            return this;

        double L = (q.y - this.y) / (q.x - this.x);
        double xx = pow(L, 2) - this.x - q.x;
        return new Pt(xx, L * (this.x - xx) - this.y);
    }

    Pt mult(int n) {
        Pt r = Pt.zero();
        Pt p = this;
        for (int i = 1; i <= n; i <<= 1) {
            if ((i & n) != 0)
                r = r.plus(p);
            p = p.dbl();
        }
        return r;
    }

    @Override
    public String toString() {
        if (isZero())
            return "Zero";
        return String.format(Locale.US, "(%.3f,%.3f)", this.x, this.y);
    }
}

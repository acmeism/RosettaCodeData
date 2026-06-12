import org.apache.commons.math3.distribution.TDistribution;

public class WelchTTest {
    public static double[] meanvar(double[] a) {
        double m = 0.0, v = 0.0;
        int n = a.length;

        for (double x: a) {
            m += x;
        }
        m /= n;

        for (double x: a) {
            v += (x - m) * (x - m);
        }
        v /= (n - 1);

        return new double[] {m, v};

    }

    public static double[] welch_ttest(double[] x, double[] y) {
        double mx, my, vx, vy, t, df, p;
        double[] res;
        int nx = x.length, ny = y.length;

        res = meanvar(x);
        mx = res[0];
        vx = res[1];

        res = meanvar(y);
        my = res[0];
        vy = res[1];

        t = (mx-my)/Math.sqrt(vx/nx+vy/ny);
        df = Math.pow(vx/nx+vy/ny, 2)/(vx*vx/(nx*nx*(nx-1))+vy*vy/(ny*ny*(ny-1)));
        TDistribution dist = new TDistribution(df);
        p = 2.0*dist.cumulativeProbability(-Math.abs(t));
        return new double[] {t, df, p};
    }

    public static void main(String[] args) {
        double x[] = {3.0, 4.0, 1.0, 2.1};
        double y[] = {490.2, 340.0, 433.9};
        double res[] = welch_ttest(x, y);
        System.out.println("t = " + res[0]);
        System.out.println("df = " + res[1]);
        System.out.println("p = " + res[2]);
    }
}

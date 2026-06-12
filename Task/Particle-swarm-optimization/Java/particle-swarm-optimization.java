import java.util.Arrays;
import java.util.Objects;
import java.util.Random;
import java.util.function.Function;

public class App {
    static class Parameters {
        double omega;
        double phip;
        double phig;

        Parameters(double omega, double phip, double phig) {
            this.omega = omega;
            this.phip = phip;
            this.phig = phig;
        }
    }

    static class State {
        int iter;
        double[] gbpos;
        double gbval;
        double[] min;
        double[] max;
        Parameters parameters;
        double[][] pos;
        double[][] vel;
        double[][] bpos;
        double[] bval;
        int nParticles;
        int nDims;

        State(int iter, double[] gbpos, double gbval, double[] min, double[] max, Parameters parameters, double[][] pos, double[][] vel, double[][] bpos, double[] bval, int nParticles, int nDims) {
            this.iter = iter;
            this.gbpos = gbpos;
            this.gbval = gbval;
            this.min = min;
            this.max = max;
            this.parameters = parameters;
            this.pos = pos;
            this.vel = vel;
            this.bpos = bpos;
            this.bval = bval;
            this.nParticles = nParticles;
            this.nDims = nDims;
        }

        void report(String testfunc) {
            System.out.printf("Test Function        : %s\n", testfunc);
            System.out.printf("Iterations           : %d\n", iter);
            System.out.printf("Global Best Position : %s\n", Arrays.toString(gbpos));
            System.out.printf("Global Best value    : %.15f\n", gbval);
        }
    }

    private static State psoInit(double[] min, double[] max, Parameters parameters, int nParticles) {
        int nDims = min.length;
        double[][] pos = new double[nParticles][];
        for (int i = 0; i < nParticles; ++i) {
            pos[i] = min.clone();
        }
        double[][] vel = new double[nParticles][nDims];
        double[][] bpos = new double[nParticles][];
        for (int i = 0; i < nParticles; ++i) {
            bpos[i] = min.clone();
        }
        double[] bval = new double[nParticles];
        for (int i = 0; i < bval.length; ++i) {
            bval[i] = Double.POSITIVE_INFINITY;
        }
        int iter = 0;
        double[] gbpos = new double[nDims];
        for (int i = 0; i < gbpos.length; ++i) {
            gbpos[i] = Double.POSITIVE_INFINITY;
        }
        double gbval = Double.POSITIVE_INFINITY;
        return new State(iter, gbpos, gbval, min, max, parameters, pos, vel, bpos, bval, nParticles, nDims);
    }

    private static Random r = new Random();

    private static State pso(Function<double[], Double> fn, State y) {
        Parameters p = y.parameters;
        double[] v = new double[y.nParticles];
        double[][] bpos = new double[y.nParticles][];
        for (int i = 0; i < y.nParticles; ++i) {
            bpos[i] = y.min.clone();
        }
        double[] bval = new double[y.nParticles];
        double[] gbpos = new double[y.nDims];
        double gbval = Double.POSITIVE_INFINITY;
        for (int j = 0; j < y.nParticles; ++j) {
            // evaluate
            v[j] = fn.apply(y.pos[j]);
            // update
            if (v[j] < y.bval[j]) {
                bpos[j] = y.pos[j];
                bval[j] = v[j];
            } else {
                bpos[j] = y.bpos[j];
                bval[j] = y.bval[j];
            }
            if (bval[j] < gbval) {
                gbval = bval[j];
                gbpos = bpos[j];
            }
        }
        double rg = r.nextDouble();
        double[][] pos = new double[y.nParticles][y.nDims];
        double[][] vel = new double[y.nParticles][y.nDims];
        for (int j = 0; j < y.nParticles; ++j) {
            // migrate
            double rp = r.nextDouble();
            boolean ok = true;
            Arrays.fill(vel[j], 0.0);
            Arrays.fill(pos[j], 0.0);
            for (int k = 0; k < y.nDims; ++k) {
                vel[j][k] = p.omega * y.vel[j][k] +
                    p.phip * rp * (bpos[j][k] - y.pos[j][k]) +
                    p.phig * rg * (gbpos[k] - y.pos[j][k]);
                pos[j][k] = y.pos[j][k] + vel[j][k];
                ok = ok && y.min[k] < pos[j][k] && y.max[k] > pos[j][k];
            }
            if (!ok) {
                for (int k = 0; k < y.nDims; ++k) {
                    pos[j][k] = y.min[k] + (y.max[k] - y.min[k]) * r.nextDouble();
                }
            }
        }
        int iter = 1 + y.iter;
        return new State(
            iter, gbpos, gbval, y.min, y.max, y.parameters,
            pos, vel, bpos, bval, y.nParticles, y.nDims
        );
    }

    private static State iterate(Function<double[], Double> fn, int n, State y) {
        State r = y;
        if (n == Integer.MAX_VALUE) {
            State old = y;
            while (true) {
                r = pso(fn, r);
                if (Objects.equals(r, old)) break;
                old = r;
            }
        } else {
            for (int i = 0; i < n; ++i) {
                r = pso(fn, r);
            }
        }
        return r;
    }

    private static double mccormick(double[] x) {
        double a = x[0];
        double b = x[1];
        return Math.sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a;
    }

    private static double michalewicz(double[] x) {
        int m = 10;
        int d = x.length;
        double sum = 0.0;
        for (int i = 1; i < d; ++i) {
            double j = x[i - 1];
            double k = Math.sin(i * j * j / Math.PI);
            sum += Math.sin(j) * Math.pow(k, 2.0 * m);
        }
        return -sum;
    }

    public static void main(String[] args) {
        State state = psoInit(
            new double[]{-1.5, -3.0},
            new double[]{4.0, 4.0},
            new Parameters(0.0, 0.6, 0.3),
            100
        );
        state = iterate(App::mccormick, 40, state);
        state.report("McCormick");
        System.out.printf("f(-.54719, -1.54719) : %.15f\n", mccormick(new double[]{-.54719, -1.54719}));
        System.out.println();

        state = psoInit(
            new double[]{0.0, 0.0},
            new double[]{Math.PI, Math.PI},
            new Parameters(0.3, 3.0, 0.3),
            1000
        );
        state = iterate(App::michalewicz, 30, state);
        state.report("Michalewicz (2D)");
        System.out.printf("f(2.20, 1.57)        : %.15f\n", michalewicz(new double[]{2.20, 1.57}));
    }
}

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

public class SimulatedAnnealingTSP {

    private static final double[] dists = calcDists();
    private static final int[] dirs = {1, -1, 10, -10, 9, 11, -11, -9}; // all 8 neighbors
    private static final Random rand = new Random();

    // distances
    private static double[] calcDists() {
        double[] dists = new double[10000];
        for (int i = 0; i < 10000; i++) {
            double ab = Math.floor(i / 100.0);
            double cd = i % 100;
            double a = Math.floor(ab / 10);
            double b = (int)ab % 10;
            double c = Math.floor(cd / 10);
            double d = (int)cd % 10;
            dists[i] = Math.hypot(a - c, b - d);
        }
        return dists;
    }

    // index into lookup table of doubles
    private static double dist(int ci, int cj) {
        return dists[cj * 100 + ci];
    }

    // energy at s, to be minimized
    private static double Es(int[] path) {
        double d = 0.0;
        for (int i = 0; i < path.length - 1; i++) {
            d += dist(path[i], path[i + 1]);
        }
        return d;
    }

    // temperature function, decreases to 0
    private static double T(int k, int kmax, int kT) {
        return (1 - (double)k / kmax) * kT;
    }

    // variation of E, from state s to state s_next
    private static double dE(int[] s, int u, int v) {
        int su = s[u], sv = s[v];
        // old
        double a = dist(s[u - 1], su);
        double b = dist(s[u + 1], su);
        double c = dist(s[v - 1], sv);
        double d = dist(s[v + 1], sv);
        // new
        double na = dist(s[u - 1], sv);
        double nb = dist(s[u + 1], sv);
        double nc = dist(s[v - 1], su);
        double nd = dist(s[v + 1], su);

        if (v == u + 1) {
            return (na + nd) - (a + d);
        } else if (u == v + 1) {
            return (nc + nb) - (c + b);
        } else {
            return (na + nb + nc + nd) - (a + b + c + d);
        }
    }

    // probability to move from s to s_next
    private static double P(double deltaE, int k, int kmax, int kT) {
        return Math.exp(-deltaE / T(k, kmax, kT));
    }

    public static void sa(int kmax, int kT) {
        rand.setSeed(System.nanoTime());

        // Create temp array with values 1 to 99
        List<Integer> temp = new ArrayList<>();
        for (int i = 0; i < 99; i++) {
            temp.add(i + 1);
        }
        Collections.shuffle(temp, rand);

        // Initialize path array
        int[] s = new int[101]; // all 0 by default
        for (int i = 0; i < 99; i++) {
            s[i + 1] = temp.get(i); // random path from 0 to 0
        }

        System.out.println("kT = " + kT);
        System.out.printf("E(s0) %f\n\n", Es(s)); // random starter

        double Emin = Es(s); // E0

        for (int k = 0; k <= kmax; k++) {
            if (k % (kmax / 10) == 0) {
                System.out.printf("k:%10d   T: %8.4f   Es: %8.4f\n", k, T(k, kmax, kT), Es(s));
            }

            int u = 1 + rand.nextInt(99); // city index 1 to 99
            int cv = s[u] + dirs[rand.nextInt(8)]; // city number

            if (cv <= 0 || cv >= 100) { // bogus city
                continue;
            }

            if (dist(s[u], cv) > 5) { // check true neighbor (eg 0 9)
                continue;
            }

            int v = s[cv]; // city index
            double deltae = dE(s, u, v);

            if (deltae < 0 || // always move if negative
                P(deltae, k, kmax, kT) >= rand.nextDouble()) {
                // Swap s[u] and s[v]
                int temp_val = s[u];
                s[u] = s[v];
                s[v] = temp_val;
                Emin += deltae;
            }
        }

        System.out.printf("\nE(s_final) %f\n", Emin);
        System.out.println("Path:");

        // output final state
        for (int i = 0; i < s.length; i++) {
            if (i > 0 && i % 10 == 0) {
                System.out.println();
            }
            System.out.printf("%4d", s[i]);
        }
        System.out.println();
    }

    public static void main(String[] args) {
        sa(1000000, 1);
    }
}

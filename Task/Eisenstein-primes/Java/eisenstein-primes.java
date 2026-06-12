import java.util.*;
import java.util.stream.*;

public class Main {

    // ω = (-1 + i * sqrt(3)) / 2
    private static final double OMEGA_REAL = -0.5;
    private static final double OMEGA_IMAG = Math.sqrt(3.0) / 2.0;

    public static void main(String[] args) {
        List<Eisentein> eisenteinPrimes = new ArrayList<>();

        for (int i = -100; i <= 100; i++) {
            for (int j = -100; j <= 100; j++) {
                Eisentein e = new Eisentein(i, j);
                if (e.isPrime()) {
                    eisenteinPrimes.add(e);
                }
            }
        }

        eisenteinPrimes.sort(Comparator
                .comparingInt(Eisentein::norm)
                .thenComparingInt(e -> e.im)
                .thenComparingInt(e -> e.re));

        System.out.println("First 100 Eisentein primes near 0:");
        for (int i = 0; i < Math.min(100, eisenteinPrimes.size()); i++) {
            System.out.print(eisenteinPrimes.get(i));
            System.out.print((i % 4 == 3) ? "\n" : "  ");
        }
    }

    private static boolean isPrimeInt(int n) {
        if (n < 2) return false;
        if (n % 2 == 0) return n == 2;
        if (n % 3 == 0) return n == 3;
        int r = (int) Math.sqrt(n);
        for (int f = 5; f <= r; f += 6) {
            if (n % f == 0 || n % (f + 2) == 0) return false;
        }
        return true;
    }

    // Class name kept as in the original Python (typo) for fidelity.
    static class Eisentein {
        final int re;
        final int im;

        Eisentein(int re, int im) {
            this.re = re;
            this.im = im;
        }

        double real() {
            // Re(re + im * ω) = re + im * Re(ω) = re - 0.5 * im
            return re + im * OMEGA_REAL;
        }

        double imag() {
            // Im(re + im * ω) = im * Im(ω) = im * sqrt(3)/2
            return im * OMEGA_IMAG;
        }

        int norm() {
            // N(a + bω) = a^2 - a b + b^2
            return re * re - re * im + im * im;
        }

        boolean isPrime() {
            if (re == 0 || im == 0 || re == im) {
                int t = Math.max(Math.abs(re), Math.abs(im));
                return isPrimeInt(t) && (t % 3 == 2);
            } else {
                return isPrimeInt(norm());
            }
        }

        @Override
        public String toString() {
            double rr = real();
            double ii = imag();
            String sgn = (ii >= 0) ? "+" : "-";
            return String.format("%7.4f %s %6.4fi", rr, sgn, Math.abs(ii));
        }
    }
}


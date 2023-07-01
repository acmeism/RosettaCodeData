public class GoldenRatio {
    static void iterate() {
        double oldPhi = 1.0, phi = 1.0, limit = 1e-5;
        int iters = 0;
        while (true) {
            phi = 1.0 + 1.0 / oldPhi;
            iters++;
            if (Math.abs(phi - oldPhi) <= limit) break;
            oldPhi = phi;
        }
        System.out.printf("Final value of phi : %16.14f\n", phi);
        double actualPhi = (1.0 + Math.sqrt(5.0)) / 2.0;
        System.out.printf("Number of iterations : %d\n", iters);
        System.out.printf("Error (approx) : %16.14f\n", phi - actualPhi);
    }

    public static void main(String[] args) {
        iterate();
    }
}

public class Feigenbaum {
    public static void main(String[] args) {
        int max_it = 13;
        int max_it_j = 10;
        double a1 = 1.0;
        double a2 = 0.0;
        double d1 = 3.2;
        double a;

        System.out.println(" i       d");
        for (int i = 2; i <= max_it; i++) {
            a = a1 + (a1 - a2) / d1;
            for (int j = 0; j < max_it_j; j++) {
                double x = 0.0;
                double y = 0.0;
                for (int k = 0; k < 1 << i; k++) {
                    y = 1.0 - 2.0 * y * x;
                    x = a - x * x;
                }
                a -= x / y;
            }
            double d = (a1 - a2) / (a - a1);
            System.out.printf("%2d    %.8f\n", i, d);
            d1 = d;
            a2 = a1;
            a1 = a;
        }
    }
}

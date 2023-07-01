public class CalculateE {
    public static final double EPSILON = 1.0e-15;

    public static void main(String[] args) {
        long fact = 1;
        double e = 2.0;
        int n = 2;
        double e0;
        do {
            e0 = e;
            fact *= n++;
            e += 1.0 / fact;
        } while (Math.abs(e - e0) >= EPSILON);
        System.out.printf("e = %.15f\n", e);
    }
}

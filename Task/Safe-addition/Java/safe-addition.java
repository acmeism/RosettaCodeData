public class SafeAddition {
    private static double stepDown(double d) {
        return Math.nextAfter(d, Double.NEGATIVE_INFINITY);
    }

    private static double stepUp(double d) {
        return Math.nextUp(d);
    }

    private static double[] safeAdd(double a, double b) {
        return new double[]{stepDown(a + b), stepUp(a + b)};
    }

    public static void main(String[] args) {
        double a = 1.2;
        double b = 0.03;
        double[] result = safeAdd(a, b);
        System.out.printf("(%.2f + %.2f) is in the range %.16f..%.16f", a, b, result[0], result[1]);
    }
}

public class KahanSummation {
    private static float kahanSum(float... fa) {
        float sum = 0.0f;
        float c = 0.0f;
        for (float f : fa) {
            float y = f - c;
            float t = sum + y;
            c = (t - sum) - y;
            sum = t;
        }
        return sum;
    }

    private static float epsilon() {
        float eps = 1.0f;
        while (1.0f + eps != 1.0f) eps /= 2.0f;
        return eps;
    }

    public static void main(String[] args) {
        float a = 1.0f;
        float b = epsilon();
        float c = -b;
        System.out.println("Epsilon      = " + b);
        System.out.println("(a + b) + c  = " + ((a + b) + c));
        System.out.println("Kahan sum    = " + kahanSum(a, b, c));
    }
}

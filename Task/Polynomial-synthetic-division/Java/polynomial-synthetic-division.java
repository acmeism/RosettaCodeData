import java.util.Arrays;

public class Test {

    public static void main(String[] args) {
        int[] N = {1, -12, 0, -42};
        int[] D = {1, -3};

        System.out.printf("%s / %s = %s",
                Arrays.toString(N),
                Arrays.toString(D),
                Arrays.deepToString(extendedSyntheticDivision(N, D)));
    }

    static int[][] extendedSyntheticDivision(int[] dividend, int[] divisor) {
        int[] out = dividend.clone();
        int normalizer = divisor[0];

        for (int i = 0; i < dividend.length - (divisor.length - 1); i++) {
            out[i] /= normalizer;

            int coef = out[i];
            if (coef != 0) {
                for (int j = 1; j < divisor.length; j++)
                    out[i + j] += -divisor[j] * coef;
            }
        }

        int separator = out.length - (divisor.length - 1);

        return new int[][]{
            Arrays.copyOfRange(out, 0, separator),
            Arrays.copyOfRange(out, separator, out.length)
        };
    }
}

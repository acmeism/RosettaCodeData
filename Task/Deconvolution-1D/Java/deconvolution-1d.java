import java.util.Arrays;

public class Deconvolution1D {
    public static int[] deconv(int[] g, int[] f) {
        int[] h = new int[g.length - f.length + 1];
        for (int n = 0; n < h.length; n++) {
            h[n] = g[n];
            int lower = Math.max(n - f.length + 1, 0);
            for (int i = lower; i < n; i++)
                h[n] -= h[i] * f[n - i];
            h[n] /= f[0];
        }
        return h;
    }

    public static void main(String[] args) {
        int[] h = { -8, -9, -3, -1, -6, 7 };
        int[] f = { -3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1 };
        int[] g = { 24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
                96, 31, 55, 36, 29, -43, -7 };

        StringBuilder sb = new StringBuilder();
        sb.append("h = " + Arrays.toString(h) + "\n");
        sb.append("deconv(g, f) = " + Arrays.toString(deconv(g, f)) + "\n");
        sb.append("f = " + Arrays.toString(f) + "\n");
        sb.append("deconv(g, h) = " + Arrays.toString(deconv(g, h)) + "\n");
        System.out.println(sb.toString());
    }
}

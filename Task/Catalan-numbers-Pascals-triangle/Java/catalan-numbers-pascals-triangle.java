public class Test {
    public static void main(String[] args) {
        int N = 15;
        int[] t = new int[N + 2];
        t[1] = 1;

        for (int i = 1; i <= N; i++) {

            for (int j = i; j > 1; j--)
                t[j] = t[j] + t[j - 1];

            t[i + 1] = t[i];

            for (int j = i + 1; j > 1; j--)
                t[j] = t[j] + t[j - 1];

            System.out.printf("%d ", t[i + 1] - t[i]);
        }
    }
}

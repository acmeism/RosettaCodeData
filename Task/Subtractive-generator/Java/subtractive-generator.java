import java.util.function.IntSupplier;
import static java.util.stream.IntStream.generate;

public class SubtractiveGenerator implements IntSupplier {
    static final int MOD = 1_000_000_000;
    private int[] state = new int[55];
    private int si, sj;

    public SubtractiveGenerator(int p1) {
        subrandSeed(p1);
    }

    void subrandSeed(int p1) {
        int p2 = 1;

        state[0] = p1 % MOD;
        for (int i = 1, j = 21; i < 55; i++, j += 21) {
            if (j >= 55)
                j -= 55;
            state[j] = p2;
            if ((p2 = p1 - p2) < 0)
                p2 += MOD;
            p1 = state[j];
        }

        si = 0;
        sj = 24;
        for (int i = 0; i < 165; i++)
            getAsInt();
    }

    @Override
    public int getAsInt() {
        if (si == sj)
            subrandSeed(0);

        if (si-- == 0)
            si = 54;
        if (sj-- == 0)
            sj = 54;

        int x = state[si] - state[sj];
        if (x < 0)
            x += MOD;

        return state[si] = x;
    }

    public static void main(String[] args) {
        generate(new SubtractiveGenerator(292_929)).limit(10)
                .forEach(System.out::println);
    }
}

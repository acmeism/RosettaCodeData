import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Main {
    private static boolean playOptimal(int n) {
        List<Integer> secretList = IntStream.range(0, n).boxed().collect(Collectors.toList());
        Collections.shuffle(secretList);

        prisoner:
        for (int i = 0; i < secretList.size(); ++i) {
            int prev = i;
            for (int j = 0; j < secretList.size() / 2; ++j) {
                if (secretList.get(prev) == i) {
                    continue prisoner;
                }
                prev = secretList.get(prev);
            }
            return false;
        }
        return true;
    }

    private static boolean playRandom(int n) {
        List<Integer> secretList = IntStream.range(0, n).boxed().collect(Collectors.toList());
        Collections.shuffle(secretList);

        prisoner:
        for (Integer i : secretList) {
            List<Integer> trialList = IntStream.range(0, n).boxed().collect(Collectors.toList());
            Collections.shuffle(trialList);

            for (int j = 0; j < trialList.size() / 2; ++j) {
                if (Objects.equals(trialList.get(j), i)) {
                    continue prisoner;
                }
            }

            return false;
        }
        return true;
    }

    private static double exec(int n, int p, Function<Integer, Boolean> play) {
        int succ = 0;
        for (int i = 0; i < n; ++i) {
            if (play.apply(p)) {
                succ++;
            }
        }
        return (succ * 100.0) / n;
    }

    public static void main(String[] args) {
        final int n = 100_000;
        final int p = 100;
        System.out.printf("# of executions: %d\n", n);
        System.out.printf("Optimal play success rate: %f%%\n", exec(n, p, Main::playOptimal));
        System.out.printf("Random play success rate: %f%%\n", exec(n, p, Main::playRandom));
    }
}

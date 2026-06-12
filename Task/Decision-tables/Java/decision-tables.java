import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Objects;

public class DecisionTables {
    private static class Pair<T, U> {
        private final T t;
        private final U u;

        public static <T, U> Pair<T, U> of(T t, U u) {
            return new Pair<>(t, u);
        }

        public Pair(T t, U u) {
            this.t = t;
            this.u = u;
        }

        public T getFirst() {
            return t;
        }

        public U getSecond() {
            return u;
        }
    }

    private static final List<Pair<String, String>> conditions = List.of(
        Pair.of("Printer prints", "NNNNYYYY"),
        Pair.of("A red light is flashing", "YYNNYYNN"),
        Pair.of("Printer is recognized by computer", "NYNYNYNY")
    );

    private static final List<Pair<String, String>> actions = List.of(
        Pair.of("Check the power cable", "NNYNNNNN"),
        Pair.of("Check the printer-computer cable", "YNYNNNNN"),
        Pair.of("Ensure printer software is installed", "YNYNYNYN"),
        Pair.of("Check/replace ink", "YYNNNYNN"),
        Pair.of("Check for paper jam", "NYNYNNNN")
    );

    public static void main(String[] args) throws IOException {
        final int nc = conditions.size();
        final int na = actions.size();
        final int nr = conditions.get(0).getSecond().length();
        final int np = 7;

        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Please answer the following questions with a y or n:");
        final boolean[] answers = new boolean[nc];
        for (int c = 0; c < nc; ++c) {
            String input;
            do {
                System.out.printf("  %s ? ", conditions.get(c).getFirst());
                input = br.readLine().toUpperCase();
            } while (!Objects.equals(input, "Y") && !Objects.equals(input, "N"));
            answers[c] = Objects.equals(input, "Y");
        }
        System.out.println("\nRecommended action(s)");

        outer:
        for (int r = 0; r < nr; ++r) {
            for (int c = 0; c < nc; ++c) {
                char yn = answers[c] ? 'Y' : 'N';
                if (conditions.get(c).getSecond().charAt(r) != yn) {
                    continue outer;
                }
            }
            if (r == np) {
                System.out.println("  None (no problem detected)");
            } else {
                for (Pair<String, String> action : actions) {
                    if (action.getSecond().charAt(r) == 'Y') {
                        System.out.printf("  %s\n", action.getFirst());
                    }
                }
            }
            break;
        }
    }
}

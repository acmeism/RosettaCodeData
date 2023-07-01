import java.util.List;
import java.util.Random;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toList;

public class Rpg {

    private static final Random random = new Random();

    public static int genAttribute() {
        return random.ints(1, 6 + 1) // Throw dices between 1 and 6
            .limit(4) // Do 5 throws
            .sorted() // Sort them
            .limit(3) // Take the top 3
            .sum();   // Sum them
    }

    public static void main(String[] args) {
        while (true) {
            List<Integer> stats =
                Stream.generate(Rpg::genAttribute) // Generate some stats
                    .limit(6) // Take 6
                    .collect(toList()); // Save them in an array
            int sum = stats.stream().mapToInt(Integer::intValue).sum();
            long count = stats.stream().filter(v -> v >= 15).count();
            if (count >= 2 && sum >= 75) {
                System.out.printf("The 6 random numbers generated are: %s\n", stats);
                System.out.printf("Their sum is %s and %s of them are >= 15\n", sum, count);
                return;
            }
        }
    }
}

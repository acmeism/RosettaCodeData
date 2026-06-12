import static java.util.Arrays.stream;
import java.util.Random;

public class Test {

    static double equalBirthdays(int nSharers, int groupSize, int nRepetitions) {
        Random rand = new Random(1);

        int eq = 0;

        for (int i = 0; i < nRepetitions; i++) {
            int[] group = new int[365];
            for (int j = 0; j < groupSize; j++)
                group[rand.nextInt(group.length)]++;
            eq += stream(group).anyMatch(c -> c >= nSharers) ? 1 : 0;
        }

        return (eq * 100.0) / nRepetitions;
    }

    public static void main(String[] a) {

        int groupEst = 2;

        for (int sharers = 2; sharers < 6; sharers++) {
            // Coarse.
            int groupSize = groupEst + 1;
            while (equalBirthdays(sharers, groupSize, 100) < 50.0)
                groupSize++;

            // Finer.
            int inf = (int) (groupSize - (groupSize - groupEst) / 4.0);
            for (int gs = inf; gs < groupSize + 999; gs++) {
                double eq = equalBirthdays(sharers, groupSize, 250);
                if (eq > 50.0) {
                    groupSize = gs;
                    break;
                }
            }

            // Finest.
            for (int gs = groupSize - 1; gs < groupSize + 999; gs++) {
                double eq = equalBirthdays(sharers, gs, 50_000);
                if (eq > 50.0) {
                    groupEst = gs;
                    System.out.printf("%d independent people in a group of "
                            + "%s share a common birthday. (%5.1f)%n",
                            sharers, gs, eq);
                    break;
                }
            }
        }
    }
}

import static java.lang.Math.abs;
import java.util.*;
import static java.util.stream.Collectors.toList;
import static java.util.stream.IntStream.range;

public class NoConnection {

    // adopted from Go
    static int[][] links = {
        {2, 3, 4}, // A to C,D,E
        {3, 4, 5}, // B to D,E,F
        {2, 4},    // D to C, E
        {5},       // E to F
        {2, 3, 4}, // G to C,D,E
        {3, 4, 5}, // H to D,E,F
    };

    static int[] pegs = new int[8];

    public static void main(String[] args) {

        List<Integer> vals = range(1, 9).mapToObj(i -> i).collect(toList());
        do {
            Collections.shuffle(vals);
            for (int i = 0; i < pegs.length; i++)
                pegs[i] = vals.get(i);

        } while (!solved());

        printResult();
    }

    static boolean solved() {
        for (int i = 0; i < links.length; i++)
            for (int peg : links[i])
                if (abs(pegs[i] - peg) == 1)
                    return false;
        return true;
    }

    static void printResult() {
        System.out.printf("  %s %s%n", pegs[0], pegs[1]);
        System.out.printf("%s %s %s %s%n", pegs[2], pegs[3], pegs[4], pegs[5]);
        System.out.printf("  %s %s%n", pegs[6], pegs[7]);
    }
}

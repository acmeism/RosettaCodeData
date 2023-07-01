import java.util.ArrayList;
import java.util.List;

public class EgyptianDivision {

    /**
     * Runs the method and divides 580 by 34
     *
     * @param args not used
     */
    public static void main(String[] args) {

        divide(580, 34);

    }

    /**
     * Divides <code>dividend</code> by <code>divisor</code> using the Egyptian Division-Algorithm and prints the
     * result to the console
     *
     * @param dividend
     * @param divisor
     */
    public static void divide(int dividend, int divisor) {

        List<Integer> powersOf2 = new ArrayList<>();
        List<Integer> doublings = new ArrayList<>();

        //populate the powersof2- and doublings-columns
        int line = 0;
        while ((Math.pow(2, line) * divisor) <= dividend) { //<- could also be done with a for-loop
            int powerOf2 = (int) Math.pow(2, line);
            powersOf2.add(powerOf2);
            doublings.add(powerOf2 * divisor);
            line++;
        }

        int answer = 0;
        int accumulator = 0;

        //Consider the rows in reverse order of their construction (from back to front of the List<>s)
        for (int i = powersOf2.size() - 1; i >= 0; i--) {
            if (accumulator + doublings.get(i) <= dividend) {
                accumulator += doublings.get(i);
                answer += powersOf2.get(i);
            }
        }

        System.out.println(String.format("%d, remainder %d", answer, dividend - accumulator));
    }
}

import java.util.ArrayList;
import java.util.List;

public class LoopsWrongRanges {

    public static void main(String[] args) {
        runTest(new LoopTest(-2, 2, 1, "Normal"));
        runTest(new LoopTest(-2, 2, 0, "Zero increment"));
        runTest(new LoopTest(-2, 2, -1, "Increments away from stop value"));
        runTest(new LoopTest(-2, 2, 10, "First increment is beyond stop value"));
        runTest(new LoopTest(2, -2, 1, "Start more than stop: positive increment"));
        runTest(new LoopTest(2, 2, 1, "Start equal stop: positive increment"));
        runTest(new LoopTest(2, 2, -1, "Start equal stop: negative increment"));
        runTest(new LoopTest(2, 2, 0, "Start equal stop: zero increment"));
        runTest(new LoopTest(0, 0, 0, "Start equal stop equal zero: zero increment"));
    }

    private static void runTest(LoopTest loopTest) {
        List<Integer> values = new ArrayList<>();
        for (int i = loopTest.start ; i <= loopTest.stop ; i += loopTest.increment ) {
            values.add(i);
            if ( values.size() >= 10 ) {
                break;
            }
        }
        System.out.printf("%-45s %s%s%n", loopTest.comment, values, values.size()==10 ? " (loops forever)" : "");
    }

    private static class LoopTest {
        int start;
        int stop;
        int increment;
        String comment;
        public LoopTest(int start, int stop, int increment, String comment) {
            this.start = start;
            this.stop = stop;
            this.increment = increment;
            this.comment = comment;
        }
    }

}

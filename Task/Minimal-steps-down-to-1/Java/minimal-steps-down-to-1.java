import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MinimalStepsDownToOne {

    public static void main(String[] args) {
        runTasks(getFunctions1());
        runTasks(getFunctions2());
        runTasks(getFunctions3());
    }

    private static void runTasks(List<Function> functions) {
        Map<Integer,List<String>> minPath = getInitialMap(functions, 5);

        //  Task 1
        int max = 10;
        populateMap(minPath, functions, max);
        System.out.printf("%nWith functions:  %s%n", functions);
        System.out.printf("  Minimum steps to 1:%n");
        for ( int n = 2 ; n <= max ; n++ ) {
            int steps = minPath.get(n).size();
            System.out.printf("    %2d: %d step%1s: %s%n", n, steps, steps == 1 ? "" : "s", minPath.get(n));
        }

        //  Task 2
        displayMaxMin(minPath, functions, 2000);

        //  Task 2a
        displayMaxMin(minPath, functions, 20000);

        //  Task 2a +
        displayMaxMin(minPath, functions, 100000);
    }

    private static void displayMaxMin(Map<Integer,List<String>> minPath, List<Function> functions, int max) {
        populateMap(minPath, functions, max);
        List<Integer> maxIntegers = getMaxMin(minPath, max);
        int maxSteps = maxIntegers.remove(0);
        int numCount = maxIntegers.size();
        System.out.printf("  There %s %d number%s in the range 1-%d that have maximum 'minimal steps' of %d:%n    %s%n", numCount == 1 ? "is" : "are", numCount, numCount == 1 ? "" : "s", max, maxSteps, maxIntegers);

    }

    private static List<Integer> getMaxMin(Map<Integer,List<String>> minPath, int max) {
        int maxSteps = Integer.MIN_VALUE;
        List<Integer> maxIntegers = new ArrayList<Integer>();
        for ( int n = 2 ; n <= max ; n++ ) {
            int len = minPath.get(n).size();
            if ( len > maxSteps ) {
                maxSteps = len;
                maxIntegers.clear();
                maxIntegers.add(n);
            }
            else if ( len == maxSteps ) {
                maxIntegers.add(n);
            }
        }
        maxIntegers.add(0, maxSteps);
        return maxIntegers;
    }

    private static void populateMap(Map<Integer,List<String>> minPath, List<Function> functions, int max) {
        for ( int n = 2 ; n <= max ; n++ ) {
            if ( minPath.containsKey(n) ) {
                continue;
            }
            Function minFunction = null;
            int minSteps = Integer.MAX_VALUE;
            for ( Function f : functions ) {
                if ( f.actionOk(n) ) {
                    int result = f.action(n);
                    int steps = 1 + minPath.get(result).size();
                    if ( steps < minSteps ) {
                        minFunction = f;
                        minSteps = steps;
                    }
                }
            }
            int result = minFunction.action(n);
            List<String> path = new ArrayList<String>();
            path.add(minFunction.toString(n));
            path.addAll(minPath.get(result));
            minPath.put(n, path);
        }

    }

    private static Map<Integer,List<String>> getInitialMap(List<Function> functions, int max) {
        Map<Integer,List<String>> minPath = new HashMap<>();
        for ( int i = 2 ; i <= max ; i++ ) {
            for ( Function f : functions ) {
                if ( f.actionOk(i) ) {
                    int result = f.action(i);
                    if ( result == 1 ) {
                        List<String> path = new ArrayList<String>();
                        path.add(f.toString(i));
                        minPath.put(i, path);
                    }
                }
            }
        }
        return minPath;
    }

    private static List<Function> getFunctions3() {
        List<Function> functions = new ArrayList<>();
        functions.add(new Divide2Function());
        functions.add(new Divide3Function());
        functions.add(new Subtract2Function());
        functions.add(new Subtract1Function());
        return functions;
    }

    private static List<Function> getFunctions2() {
        List<Function> functions = new ArrayList<>();
        functions.add(new Divide3Function());
        functions.add(new Divide2Function());
        functions.add(new Subtract2Function());
        return functions;
    }

    private static List<Function> getFunctions1() {
        List<Function> functions = new ArrayList<>();
        functions.add(new Divide3Function());
        functions.add(new Divide2Function());
        functions.add(new Subtract1Function());
        return functions;
    }

    public abstract static class Function {
        abstract public int action(int n);
        abstract public boolean actionOk(int n);
        abstract public String toString(int n);
    }

    public static class Divide2Function extends Function {
        @Override public int action(int n) {
            return n/2;
        }

        @Override public boolean actionOk(int n) {
            return n % 2 == 0;
        }

        @Override public String toString(int n) {
            return "/2 -> " + n/2;
        }

        @Override public String toString() {
            return "Divisor 2";
        }

    }

    public static class Divide3Function extends Function {
        @Override public int action(int n) {
            return n/3;
        }

        @Override public boolean actionOk(int n) {
            return n % 3 == 0;
        }

        @Override public String toString(int n) {
            return "/3 -> " + n/3;
        }

        @Override public String toString() {
            return "Divisor 3";
        }

    }

    public static class Subtract1Function extends Function {
        @Override public int action(int n) {
            return n-1;
        }

        @Override public boolean actionOk(int n) {
            return true;
        }

        @Override public String toString(int n) {
            return "-1 -> " + (n-1);
        }

        @Override public String toString() {
            return "Subtractor 1";
        }

    }

    public static class Subtract2Function extends Function {
        @Override public int action(int n) {
            return n-2;
        }

        @Override public boolean actionOk(int n) {
            return n > 2;
        }

        @Override public String toString(int n) {
            return "-2 -> " + (n-2);
        }

        @Override public String toString() {
            return "Subtractor 2";
        }

    }

}

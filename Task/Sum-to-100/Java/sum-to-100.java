/*
 * RossetaCode: Sum to 100, Java 8.
 *
 * Find solutions to the "sum to one hundred" puzzle.
 */
package rosettacode;

import java.io.PrintStream;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class SumTo100 implements Runnable {

    public static void main(String[] args) {
        new SumTo100().run();
    }

    void print(int givenSum) {
        Expression expression = new Expression();
        for (int i = 0; i < Expression.NUMBER_OF_EXPRESSIONS; i++, expression.next()) {
            if (expression.toInt() == givenSum) {
                expression.print();
            }
        }
    }

    void comment(String commentString) {
        System.out.println();
        System.out.println(commentString);
        System.out.println();
    }

    @Override
    public void run() {
        final Stat stat = new Stat();

        comment("Show all solutions that sum to 100");
        final int givenSum = 100;
        print(givenSum);

        comment("Show the sum that has the maximum number of solutions");
        final int maxCount = Collections.max(stat.sumCount.keySet());
        int maxSum;
        Iterator<Integer> it = stat.sumCount.get(maxCount).iterator();
        do {
            maxSum = it.next();
        } while (maxSum < 0);
        System.out.println(maxSum + " has " + maxCount + " solutions");

        comment("Show the lowest positive number that can't be expressed");
        int value = 0;
        while (stat.countSum.containsKey(value)) {
            value++;
        }
        System.out.println(value);

        comment("Show the ten highest numbers that can be expressed");
        final int n = stat.countSum.keySet().size();
        final Integer[] sums = stat.countSum.keySet().toArray(new Integer[n]);
        Arrays.sort(sums);
        for (int i = n - 1; i >= n - 10; i--) {
            print(sums[i]);
        }
    }

    private static class Expression {

        private final static int NUMBER_OF_DIGITS = 9;
        private final static byte ADD = 0;
        private final static byte SUB = 1;
        private final static byte JOIN = 2;

        final byte[] code = new byte[NUMBER_OF_DIGITS];
        final static int NUMBER_OF_EXPRESSIONS = 2 * 3 * 3 * 3 * 3 * 3 * 3 * 3 * 3;

        Expression next() {
            for (int i = 0; i < NUMBER_OF_DIGITS; i++) {
                if (++code[i] > JOIN) {
                    code[i] = ADD;
                } else {
                    break;
                }
            }
            return this;
        }

        int toInt() {
            int value = 0;
            int number = 0;
            int sign = (+1);
            for (int digit = 1; digit <= 9; digit++) {
                switch (code[NUMBER_OF_DIGITS - digit]) {
                    case ADD:
                        value += sign * number;
                        number = digit;
                        sign = (+1);
                        break;
                    case SUB:
                        value += sign * number;
                        number = digit;
                        sign = (-1);
                        break;
                    case JOIN:
                        number = 10 * number + digit;
                        break;
                }
            }
            return value + sign * number;
        }

        @Override
        public String toString() {
            StringBuilder s = new StringBuilder(2 * NUMBER_OF_DIGITS + 1);
            for (int digit = 1; digit <= NUMBER_OF_DIGITS; digit++) {
                switch (code[NUMBER_OF_DIGITS - digit]) {
                    case ADD:
                        if (digit > 1) {
                            s.append('+');
                        }
                        break;
                    case SUB:
                        s.append('-');
                        break;
                }
                s.append(digit);
            }
            return s.toString();
        }

        void print() {
            print(System.out);
        }

        void print(PrintStream printStream) {
            printStream.format("%9d", this.toInt());
            printStream.println(" = " + this);
        }
    }

    private static class Stat {

        final Map<Integer, Integer> countSum = new HashMap<>();
        final Map<Integer, Set<Integer>> sumCount = new HashMap<>();

        Stat() {
            Expression expression = new Expression();
            for (int i = 0; i < Expression.NUMBER_OF_EXPRESSIONS; i++, expression.next()) {
                int sum = expression.toInt();
                countSum.put(sum, countSum.getOrDefault(sum, 0) + 1);
            }
            for (Map.Entry<Integer, Integer> entry : countSum.entrySet()) {
                Set<Integer> set;
                if (sumCount.containsKey(entry.getValue())) {
                    set = sumCount.get(entry.getValue());
                } else {
                    set = new HashSet<>();
                }
                set.add(entry.getKey());
                sumCount.put(entry.getValue(), set);
            }
        }
    }
}

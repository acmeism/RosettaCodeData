package stringlensort;

import java.io.PrintStream;
import java.util.Arrays;
import java.util.Comparator;

public class ReportStringLengths {

    public static void main(String[] args) {
        String[] list = {"abcd", "123456789", "abcdef", "1234567"};
        String[] strings = args.length > 0 ? args : list;

        compareAndReportStringsLength(strings);
    }

    /**
     * Compare and report strings length to System.out.
     *
     * @param strings an array of strings
     */
    public static void compareAndReportStringsLength(String[] strings) {
        compareAndReportStringsLength(strings, System.out);
    }

    /**
     * Compare and report strings length.
     *
     * @param strings an array of strings
     * @param stream the output stream to write results
     */
    public static void compareAndReportStringsLength(String[] strings, PrintStream stream) {
        if (strings.length > 0) {
            strings = strings.clone();
            final String QUOTE = "\"";
            Arrays.sort(strings, Comparator.comparing(String::length));
            int min = strings[0].length();
            int max = strings[strings.length - 1].length();
            for (int i = strings.length - 1; i >= 0; i--) {
                int length = strings[i].length();
                String predicate;
                if (length == max) {
                    predicate = "is the longest string";
                } else if (length == min) {
                    predicate = "is the shortest string";
                } else {
                    predicate = "is neither the longest nor the shortest string";
                }
                //@todo: StringBuilder may be faster
                stream.println(QUOTE + strings[i] + QUOTE + " has length " + length
                        + " and " + predicate);
            }
        }
    }
}

import java.util.*;
import static java.util.Arrays.stream;
import static java.util.stream.Collectors.toList;

public class Nonoblock {

    public static void main(String[] args) {
        printBlock("21", 5);
        printBlock("", 5);
        printBlock("8", 10);
        printBlock("2323", 15);
        printBlock("23", 5);
    }

    static void printBlock(String data, int len) {
        int sumChars = data.chars().map(c -> Character.digit(c, 10)).sum();
        String[] a = data.split("");

        System.out.printf("%nblocks %s, cells %s%n", Arrays.toString(a), len);
        if (len - sumChars <= 0) {
            System.out.println("No solution");
            return;
        }

        List<String> prep = stream(a).filter(x -> !"".equals(x))
                .map(x -> repeat(Character.digit(x.charAt(0), 10), "1"))
                .collect(toList());

        for (String r : genSequence(prep, len - sumChars + 1))
            System.out.println(r.substring(1));
    }

    // permutation generator, translated from Python via D
    static List<String> genSequence(List<String> ones, int numZeros) {
        if (ones.isEmpty())
            return Arrays.asList(repeat(numZeros, "0"));

        List<String> result = new ArrayList<>();
        for (int x = 1; x < numZeros - ones.size() + 2; x++) {
            List<String> skipOne = ones.stream().skip(1).collect(toList());
            for (String tail : genSequence(skipOne, numZeros - x))
                result.add(repeat(x, "0") + ones.get(0) + tail);
        }
        return result;
    }

    static String repeat(int n, String s) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++)
            sb.append(s);
        return sb.toString();
    }
}

import java.util.Arrays;

public class CompareListOfStrings {

    public static void main(String[] args) {
        String[][] arr = {{"AA", "AA", "AA", "AA"}, {"AA", "ACB", "BB", "CC"}};
        for (String[] a : arr) {
            System.out.println(Arrays.toString(a));
            System.out.println(Arrays.stream(a).distinct().count() < 2);
            System.out.println(Arrays.equals(Arrays.stream(a).distinct().sorted().toArray(), a));
        }
    }
}

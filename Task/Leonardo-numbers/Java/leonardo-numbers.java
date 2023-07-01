import java.util.Arrays;
import java.util.List;

@SuppressWarnings("SameParameterValue")
public class LeonardoNumbers {
    private static List<Integer> leonardo(int n) {
        return leonardo(n, 1, 1, 1);
    }

    private static List<Integer> leonardo(int n, int l0, int l1, int add) {
        Integer[] leo = new Integer[n];
        leo[0] = l0;
        leo[1] = l1;
        for (int i = 2; i < n; i++) {
            leo[i] = leo[i - 1] + leo[i - 2] + add;
        }
        return Arrays.asList(leo);
    }

    public static void main(String[] args) {
        System.out.println("The first 25 Leonardo numbers with L[0] = 1, L[1] = 1 and add number = 1 are:");
        System.out.println(leonardo(25));
        System.out.println("\nThe first 25 Leonardo numbers with L[0] = 0, L[1] = 1 and add number = 0 are:");
        System.out.println(leonardo(25, 0, 1, 0));
    }
}

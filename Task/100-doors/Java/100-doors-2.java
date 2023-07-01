import java.util.BitSet;

public class HundredDoors {
    public static void main(String[] args) {
        final int n = 100;
        var a = new BitSet(n);
        for (int i = 1; i <= n; i++) {
            for (int j = i - 1; j < n; j += i) {
                a.flip(j);
            }
        }
        a.stream().map(i -> i + 1).forEachOrdered(System.out::println);
    }
}

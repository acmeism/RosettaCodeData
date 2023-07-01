import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

public class RandomLatinSquares {
    private static void printSquare(List<List<Integer>> latin) {
        for (List<Integer> row : latin) {
            Iterator<Integer> it = row.iterator();

            System.out.print("[");
            if (it.hasNext()) {
                Integer col = it.next();
                System.out.print(col);
            }
            while (it.hasNext()) {
                Integer col = it.next();
                System.out.print(", ");
                System.out.print(col);
            }
            System.out.println("]");
        }
        System.out.println();
    }

    private static void latinSquare(int n) {
        if (n <= 0) {
            System.out.println("[]");
            return;
        }

        List<List<Integer>> latin = new ArrayList<>(n);
        for (int i = 0; i < n; ++i) {
            List<Integer> inner = new ArrayList<>(n);
            for (int j = 0; j < n; ++j) {
                inner.add(j);
            }
            latin.add(inner);
        }
        // first row
        Collections.shuffle(latin.get(0));

        // middle row(s)
        for (int i = 1; i < n - 1; ++i) {
            boolean shuffled = false;
            shuffling:
            while (!shuffled) {
                Collections.shuffle(latin.get(i));
                for (int k = 0; k < i; ++k) {
                    for (int j = 0; j < n; ++j) {
                        if (Objects.equals(latin.get(k).get(j), latin.get(i).get(j))) {
                            continue shuffling;
                        }
                    }
                }
                shuffled = true;
            }
        }

        // last row
        for (int j = 0; j < n; ++j) {
            List<Boolean> used = new ArrayList<>(n);
            for (int i = 0; i < n; ++i) {
                used.add(false);
            }
            for (int i = 0; i < n - 1; ++i) {
                used.set(latin.get(i).get(j), true);
            }
            for (int k = 0; k < n; ++k) {
                if (!used.get(k)) {
                    latin.get(n - 1).set(j, k);
                    break;
                }
            }
        }

        printSquare(latin);
    }

    public static void main(String[] args) {
        latinSquare(5);
        latinSquare(5);
        latinSquare(10);
    }
}

import java.util.ArrayList;
import java.util.List;

public class Bell {
    private static class BellTriangle {
        private List<Integer> arr;

        BellTriangle(int n) {
            int length = n * (n + 1) / 2;
            arr = new ArrayList<>(length);
            for (int i = 0; i < length; ++i) {
                arr.add(0);
            }

            set(1, 0, 1);
            for (int i = 2; i <= n; ++i) {
                set(i, 0, get(i - 1, i - 2));
                for (int j = 1; j < i; ++j) {
                    int value = get(i, j - 1) + get(i - 1, j - 1);
                    set(i, j, value);
                }
            }
        }

        private int index(int row, int col) {
            if (row > 0 && col >= 0 && col < row) {
                return row * (row - 1) / 2 + col;
            } else {
                throw new IllegalArgumentException();
            }
        }

        public int get(int row, int col) {
            int i = index(row, col);
            return arr.get(i);
        }

        public void set(int row, int col, int value) {
            int i = index(row, col);
            arr.set(i, value);
        }
    }

    public static void main(String[] args) {
        final int rows = 15;
        BellTriangle bt = new BellTriangle(rows);

        System.out.println("First fifteen Bell numbers:");
        for (int i = 0; i < rows; ++i) {
            System.out.printf("%2d: %d\n", i + 1, bt.get(i + 1, 0));
        }

        for (int i = 1; i <= 10; ++i) {
            System.out.print(bt.get(i, 0));
            for (int j = 1; j < i; ++j) {
                System.out.printf(", %d", bt.get(i, j));
            }
            System.out.println();
        }
    }
}

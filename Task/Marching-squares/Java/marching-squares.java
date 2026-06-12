import java.util.ArrayList;
import java.util.List;

public class PerimeterDetection {
    // Direction constants
    private static final int E = 0;
    private static final int N = 1;
    private static final int W = 2;
    private static final int S = 3;

    // X generates coordinate pairs for a grid of given dimensions
    public static List<int[]> X(int a, int b) {
        List<int[]> c = new ArrayList<>();
        for (int aa = 0; aa <= a; aa++) {
            for (int bb = 0; bb <= b; bb++) {
                c.add(new int[]{aa, bb});
            }
        }
        return c;
    }

    // any checks if any element in the array equals val
    public static boolean any(int[] arr, int val) {
        for (int v : arr) {
            if (v == val) {
                return true;
            }
        }
        return false;
    }

    // Result class to return multiple values from identifyPerimeter
    public static class PerimeterResult {
        public final int x;
        public final int y;
        public final String path;

        public PerimeterResult(int x, int y, String path) {
            this.x = x;
            this.y = y;
            this.path = path;
        }
    }

    // identifyPerimeter identifies the perimeter of a shape in a 2D matrix
    public static PerimeterResult identifyPerimeter(int[][] data) {
        for (int[] coords : X(data[0].length - 1, data.length - 1)) {
            int x = coords[0];
            int y = coords[1];

            if (y < data.length && x < data[0].length && data[y][x] != 0) {
                StringBuilder path = new StringBuilder();
                int cx = x, cy = y;
                int d = 0, p = 0;

                do {
                    int mask = 0;

                    int[][] vals = {{0, 0, 1}, {1, 0, 2}, {0, 1, 4}, {1, 1, 8}};
                    for (int[] val : vals) {
                        int dx = val[0], dy = val[1], b = val[2];
                        int mx = cx + dx, my = cy + dy;

                        if (mx > 0 && my > 0 && my - 1 < data.length &&
                            mx - 1 < data[0].length && data[my - 1][mx - 1] != 0) {
                            mask += b;
                        }
                    }

                    if (any(new int[]{1, 5, 13}, mask)) {
                        d = N;
                    }
                    if (any(new int[]{2, 3, 7}, mask)) {
                        d = E;
                    }
                    if (any(new int[]{4, 12, 14}, mask)) {
                        d = W;
                    }
                    if (any(new int[]{8, 10, 11}, mask)) {
                        d = S;
                    }
                    if (mask == 6) {
                        if (p == N) {
                            d = W;
                        } else {
                            d = E;
                        }
                    }
                    if (mask == 9) {
                        if (p == E) {
                            d = N;
                        } else {
                            d = S;
                        }
                    }

                    char[] dirChars = {'E', 'N', 'W', 'S'};
                    path.append(dirChars[d]);
                    p = d;

                    int[] dxVals = {1, 0, -1, 0};
                    int[] dyVals = {0, -1, 0, 1};
                    cx += dxVals[d];
                    cy += dyVals[d];

                } while (!(cx == x && cy == y));

                return new PerimeterResult(x, -y, path.toString());
            }
        }

        System.out.println("That did not work out...");
        System.exit(1);
        return null; // This line will never be reached due to System.exit
    }

    public static void main(String[] args) {
        int[][] M = {
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 1, 1, 0},
            {0, 0, 1, 1, 0},
            {0, 0, 0, 1, 0},
            {0, 0, 0, 0, 0}
        };

        PerimeterResult result = identifyPerimeter(M);
        System.out.printf("X: %d, Y: %d, Path: %s%n", result.x, result.y, result.path);
    }
}

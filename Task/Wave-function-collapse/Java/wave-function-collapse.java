import java.util.Random;
import java.util.ArrayList;
import java.util.List;

public class WaveFunctionCollapse {

    // Define the blocks as a 3D array
    private static final int[][][] blocks = {
        {
            {0, 0, 0},
            {0, 0, 0},
            {0, 0, 0}
        },
        {
            {0, 0, 0},
            {1, 1, 1},
            {0, 1, 0}
        },
        {
            {0, 1, 0},
            {0, 1, 1},
            {0, 1, 0}
        },
        {
            {0, 1, 0},
            {1, 1, 1},
            {0, 0, 0}
        },
        {
            {0, 1, 0},
            {1, 1, 0},
            {0, 1, 0}
        }
    };

    private static Random random = new Random();

    // Helper methods for array indexing
    private static int XY(int row, int col, int width) {
        return col + row * width;
    }

    private static int XYZ(int page, int row, int col, int height, int width) {
        return XY(XY(page, row, height), col, width);
    }

    // Modulo operation that handles negative numbers correctly
    private static int MOD(int x, int y) {
        return ((y + x) % y);
    }

    public static int[][] wfc(int[][][] blocks, int[] bdim, int[] tdim) {
        int N = tdim[0] * tdim[1];
        int td0 = tdim[0], td1 = tdim[1];

        // Indices in R of the four adjacent blocks
        int[][] adj = new int[N][4];
        for (int i = 0; i < td0; i++) {
            for (int j = 0; j < td1; j++) {
                adj[XY(i, j, td1)][0] = XY(MOD(i - 1, td0), MOD(j, td1), td1); // above
                adj[XY(i, j, td1)][1] = XY(MOD(i, td0), MOD(j - 1, td1), td1); // left
                adj[XY(i, j, td1)][2] = XY(MOD(i, td0), MOD(j + 1, td1), td1); // right
                adj[XY(i, j, td1)][3] = XY(MOD(i + 1, td0), MOD(j, td1), td1); // below
            }
        }

        int bd0 = bdim[0], bd1 = bdim[1], bd2 = bdim[2];

        // Blocks which can sit next to each other horizontally
        boolean[][] horz = new boolean[bd0][bd0];
        for (int i = 0; i < bd0; i++) {
            for (int j = 0; j < bd0; j++) {
                horz[i][j] = true;
                for (int k = 0; k < bd1; k++) {
                    if (blocks[i][k][0] != blocks[j][k][bd2 - 1]) {
                        horz[i][j] = false;
                        break;
                    }
                }
            }
        }

        // Blocks which can sit next to each other vertically
        boolean[][] vert = new boolean[bd0][bd0];
        for (int i = 0; i < bd0; i++) {
            for (int j = 0; j < bd0; j++) {
                vert[i][j] = true;
                for (int k = 0; k < bd2; k++) {
                    if (blocks[i][0][k] != blocks[j][bd1 - 1][k]) {
                        vert[i][j] = false;
                        break;
                    }
                }
            }
        }

        // All block constraints, based on neighbors
        boolean[][][] allow = new boolean[4][bd0 + 1][bd0];
        for (int dir = 0; dir < 4; dir++) {
            for (int i = 0; i < bd0 + 1; i++) {
                for (int j = 0; j < bd0; j++) {
                    allow[dir][i][j] = true;
                }
            }
        }

        for (int i = 0; i < bd0; i++) {
            for (int j = 0; j < bd0; j++) {
                allow[0][i][j] = vert[j][i]; // above (north)
                allow[1][i][j] = horz[j][i]; // left (west)
                allow[2][i][j] = horz[i][j]; // right (east)
                allow[3][i][j] = vert[i][j]; // below (south)
            }
        }

        int[] R = new int[N]; // tile expressed as list of block indices
        for (int i = 0; i < N; i++) {
            R[i] = bd0; // Initialize with "undecided" value
        }

        while (true) {
            List<Integer> todo = new ArrayList<>();
            for (int i = 0; i < N; i++) {
                if (R[i] == bd0) {
                    todo.add(i);
                }
            }

            if (todo.isEmpty()) break;

            int min = bd0;
            int[] entropy = new int[todo.size()];
            boolean[][] wave = new boolean[todo.size()][bd0];

            for (int i = 0; i < todo.size(); i++) {
                entropy[i] = 0;
                int cell = todo.get(i);

                for (int j = 0; j < bd0; j++) {
                    wave[i][j] = allow[0][R[adj[cell][0]]][j] &
                                 allow[1][R[adj[cell][1]]][j] &
                                 allow[2][R[adj[cell][2]]][j] &
                                 allow[3][R[adj[cell][3]]][j];

                    if (wave[i][j]) {
                        entropy[i]++;
                    }
                }

                if (entropy[i] < min) {
                    min = entropy[i];
                }
            }

            if (min == 0) {
                return null; // No valid solution
            }

            List<Integer> indices = new ArrayList<>();
            for (int i = 0; i < todo.size(); i++) {
                if (entropy[i] == min) {
                    indices.add(i);
                }
            }

            int ndx = indices.get(random.nextInt(indices.size()));

            List<Integer> possible = new ArrayList<>();
            for (int i = 0; i < bd0; i++) {
                if (wave[ndx][i]) {
                    possible.add(i);
                }
            }

            R[todo.get(ndx)] = possible.get(random.nextInt(possible.size()));
        }

        // Create the final tile
        int tileHeight = 1 + td0 * (bd1 - 1);
        int tileWidth = 1 + td1 * (bd2 - 1);
        int[][] tile = new int[tileHeight][tileWidth];

        for (int i0 = 0; i0 < td0; i0++) {
            for (int i1 = 0; i1 < bd1; i1++) {
                for (int j0 = 0; j0 < td1; j0++) {
                    for (int j1 = 0; j1 < bd2; j1++) {
                        int blockIdx = R[XY(i0, j0, td1)];
                        int tileRow = i0 * (bd1 - 1) + i1;
                        int tileCol = j0 * (bd2 - 1) + j1;

                        if (tileRow < tileHeight && tileCol < tileWidth) {
                            tile[tileRow][tileCol] = blocks[blockIdx][i1][j1];
                        }
                    }
                }
            }
        }

        return tile;
    }

    public static void main(String[] args) {
        int[] bdims = {5, 3, 3};
        int[] size = {8, 8};

        random.setSeed(System.currentTimeMillis());

        int[][] tile = wfc(blocks, bdims, size);

        if (tile == null) {
            System.out.println("No valid solution found");
            System.exit(0);
        }

        // Print the result
        for (int i = 0; i < tile.length; i++) {
            for (int j = 0; j < tile[0].length; j++) {
                System.out.print((tile[i][j] == 0 ? " " : "#") + " ");
            }
            System.out.println();
        }
    }
}

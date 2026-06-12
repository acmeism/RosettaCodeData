import java.util.Arrays;
import java.util.stream.IntStream;

public class RamseysTheorem {

    static char[][] createMatrix() {
        String r = "-" + Integer.toBinaryString(53643);
        int len = r.length();
        return IntStream.range(0, len)
                .mapToObj(i -> r.substring(len - i) + r.substring(0, len - i))
                .map(String::toCharArray)
                .toArray(char[][]::new);
    }

    /**
     * Check that every clique of four has at least one pair connected and one
     * pair unconnected. It requires a symmetric matrix.
     */
    static String ramseyCheck(char[][] mat) {
        int len = mat.length;
        char[] connectivity = "------".toCharArray();

        for (int a = 0; a < len; a++) {
            for (int b = 0; b < len; b++) {
                if (a == b)
                    continue;
                connectivity[0] = mat[a][b];
                for (int c = 0; c < len; c++) {
                    if (a == c || b == c)
                        continue;
                    connectivity[1] = mat[a][c];
                    connectivity[2] = mat[b][c];
                    for (int d = 0; d < len; d++) {
                        if (a == d || b == d || c == d)
                            continue;
                        connectivity[3] = mat[a][d];
                        connectivity[4] = mat[b][d];
                        connectivity[5] = mat[c][d];

                        // We've extracted a meaningful subgraph,
                        // check its connectivity.
                        String conn = new String(connectivity);
                        if (conn.indexOf('0') == -1)
                            return String.format("Fail, found wholly connected: "
                                    + "%d %d %d %d", a, b, c, d);
                        else if (conn.indexOf('1') == -1)
                            return String.format("Fail, found wholly unconnected: "
                                    + "%d %d %d %d", a, b, c, d);
                    }
                }
            }
        }
        return "Satisfies Ramsey condition.";
    }

    public static void main(String[] a) {
        char[][] mat = createMatrix();
        for (char[] s : mat)
            System.out.println(Arrays.toString(s));
        System.out.println(ramseyCheck(mat));
    }
}

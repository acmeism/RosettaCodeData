import java.util.Arrays;

public class LinearCombination {
    private static String linearCombo(int[] c) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < c.length; ++i) {
            if (c[i] == 0) continue;
            String op;
            if (c[i] < 0 && sb.length() == 0) {
                op = "-";
            } else if (c[i] < 0) {
                op = " - ";
            } else if (c[i] > 0 && sb.length() == 0) {
                op = "";
            } else {
                op = " + ";
            }
            int av = Math.abs(c[i]);
            String coeff = av == 1 ? "" : "" + av + "*";
            sb.append(op).append(coeff).append("e(").append(i + 1).append(')');
        }
        if (sb.length() == 0) {
            return "0";
        }
        return sb.toString();
    }

    public static void main(String[] args) {
        int[][] combos = new int[][]{
            new int[]{1, 2, 3},
            new int[]{0, 1, 2, 3},
            new int[]{1, 0, 3, 4},
            new int[]{1, 2, 0},
            new int[]{0, 0, 0},
            new int[]{0},
            new int[]{1, 1, 1},
            new int[]{-1, -1, -1},
            new int[]{-1, -2, 0, -3},
            new int[]{-1},
        };
        for (int[] c : combos) {
            System.out.printf("%-15s  ->  %s\n", Arrays.toString(c), linearCombo(c));
        }
    }
}

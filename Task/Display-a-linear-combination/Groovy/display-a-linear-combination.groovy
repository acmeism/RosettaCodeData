class LinearCombination {
    private static String linearCombo(int[] c) {
        StringBuilder sb = new StringBuilder()
        for (int i = 0; i < c.length; ++i) {
            if (c[i] == 0) continue
            String op
            if (c[i] < 0 && sb.length() == 0) {
                op = "-"
            } else if (c[i] < 0) {
                op = " - "
            } else if (c[i] > 0 && sb.length() == 0) {
                op = ""
            } else {
                op = " + "
            }
            int av = Math.abs(c[i])
            String coeff = av == 1 ? "" : "" + av + "*"
            sb.append(op).append(coeff).append("e(").append(i + 1).append(')')
        }
        if (sb.length() == 0) {
            return "0"
        }
        return sb.toString()
    }

    static void main(String[] args) {
        int[][] combos = [
                [1, 2, 3],
                [0, 1, 2, 3],
                [1, 0, 3, 4],
                [1, 2, 0],
                [0, 0, 0],
                [0],
                [1, 1, 1],
                [-1, -1, -1],
                [-1, -2, 0, -3],
                [-1]
        ]

        for (int[] c : combos) {
            printf("%-15s  ->  %s\n", Arrays.toString(c), linearCombo(c))
        }
    }
}

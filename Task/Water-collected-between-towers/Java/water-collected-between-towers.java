public class WaterBetweenTowers {
    public static void main(String[] args) {
        int i = 1;
        int[][] tba = new int[][]{
            new int[]{1, 5, 3, 7, 2},
            new int[]{5, 3, 7, 2, 6, 4, 5, 9, 1, 2},
            new int[]{2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1},
            new int[]{5, 5, 5, 5},
            new int[]{5, 6, 7, 8},
            new int[]{8, 7, 7, 6},
            new int[]{6, 7, 10, 7, 6}
        };

        for (int[] tea : tba) {
            int rht, wu = 0, bof;
            do {
                for (rht = tea.length - 1; rht >= 0; rht--) {
                    if (tea[rht] > 0) {
                        break;
                    }
                }

                if (rht < 0) {
                    break;
                }

                bof = 0;
                for (int col = 0; col <= rht; col++) {
                    if (tea[col] > 0) {
                        tea[col]--;
                        bof += 1;
                    } else if (bof > 0) {
                        wu++;
                    }
                }
                if (bof < 2) {
                    break;
                }
            } while (true);

            System.out.printf("Block %d", i++);
            if (wu == 0) {
                System.out.print(" does not hold any");
            } else {
                System.out.printf(" holds %d", wu);
            }
            System.out.println(" water units.");
        }
    }
}

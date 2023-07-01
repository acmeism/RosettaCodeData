public class DepartmentNumbers {
    public static void main(String[] args) {
        System.out.println("Police  Sanitation  Fire");
        System.out.println("------  ----------  ----");
        int count = 0;
        for (int i = 2; i <= 6; i += 2) {
            for (int j = 1; j <= 7; ++j) {
                if (j == i) continue;
                for (int k = 1; k <= 7; ++k) {
                    if (k == i || k == j) continue;
                    if (i + j + k != 12) continue;
                    System.out.printf("  %d         %d         %d\n", i, j, k);
                    count++;
                }
            }
        }
        System.out.printf("\n%d valid combinations", count);
    }
}

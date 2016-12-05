public class MultiplicationTable {
    public static void main(String[] args) {
        for (int i = 1; i <= 12; i++)
            System.out.print("\t" + i);

        System.out.println();
        for (int i = 0; i < 100; i++)
            System.out.print("-");
        System.out.println();
        for (int i = 1; i <= 12; i++) {
            System.out.print(i + "|");
            for(int j = 1; j <= 12; j++) {
                System.out.print("\t");
                if (j >= i)
                    System.out.print("\t" + i * j);
            }
            System.out.println();
        }
    }
}

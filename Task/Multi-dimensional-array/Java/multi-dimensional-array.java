public class MultiDimensionalArray {
    public static void main(String[] args) {
        // create a regular 4 dimensional array and initialize successive elements to the values 1 to 120
        int m = 1;
        int[][][][] a4 = new int[5][4][3][2];
        for (int i = 0; i < a4.length; ++i) {
            for (int j = 0; j < a4[0].length; ++j) {
                for (int k = 0; k < a4[0][0].length; ++k) {
                    for (int l = 0; l < a4[0][0][0].length; ++l) {
                        a4[i][j][k][l] = m++;
                    }
                }
            }
        }

        System.out.println("First element = " + a4[0][0][0][0]);  // access and print value of first element
        a4[0][0][0][0] = 121;                                     // change value of first element
        System.out.println();

        for (int i = 0; i < a4.length; ++i) {
            for (int j = 0; j < a4[0].length; ++j) {
                for (int k = 0; k < a4[0][0].length; ++k) {
                    for (int l = 0; l < a4[0][0][0].length; ++l) {
                        System.out.printf("%4d", a4[i][j][k][l]);
                    }
                }
            }
        }
    }
}

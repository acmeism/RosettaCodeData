public static void main(String[] args) {
    int[][] matrix = {{1, 3, 7, 8, 10},
                      {2, 4, 16, 14, 4},
                      {3, 1, 9, 18, 11},
                      {12, 14, 17, 18, 20},
                      {7, 1, 3, 9, 5}};
    int sum = 0;
    for (int row = 1; row < matrix.length; row++) {
        for (int col = 0; col < row; col++) {
            sum += matrix[row][col];
        }
    }
    System.out.println(sum);
}

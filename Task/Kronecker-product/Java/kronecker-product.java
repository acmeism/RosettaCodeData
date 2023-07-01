package kronecker;

/**
 * Defines a function to calculate the Kronecker product of two
 * rectangular matrices and tests it with two examples.
 */
public class Product {
  /**
   * Find the Kronecker product of the arguments.
   * @param a The first matrix to multiply.
   * @param b The second matrix to multiply.
   * @return A new matrix: the Kronecker product of the arguments.
   */
  public static int[][] product(final int[][] a, final int[][] b) {
    // Create matrix c as the matrix to fill and return.
    // The length of a matrix is its number of rows.
    final int[][] c = new int[a.length*b.length][];
    // Fill in the (empty) rows of c.
    // The length of each row is the number of columns.
    for (int ix = 0; ix < c.length; ix++) {
      final int num_cols = a[0].length*b[0].length;
      c[ix] = new int[num_cols];
    }
    // Now fill in the values: the products of each pair.
    // Go through all the elements of a.
    for (int ia = 0; ia < a.length; ia++) {
      for (int ja = 0; ja < a[ia].length; ja++) {
        // For each element of a, multiply it by all the elements of b.
        for (int ib = 0; ib < b.length; ib++) {
          for (int jb = 0; jb < b[ib].length; jb++) {
             c[b.length*ia+ib][b[ib].length*ja+jb] = a[ia][ja] * b[ib][jb];
          }
        }
      }
    }

    // Return the completed product matrix c.
    return c;
  }

  /**
   * Print an integer matrix, lining up the columns by the width
   * of the longest printed element.
   * @param m The matrix to print.
   */
  public static void print_matrix(final int[][] m) {
    // Printing the matrix neatly is the most complex part.
    // For clean formatting, convert each number to a string
    // and find length of the longest of these strings.
    // Build a matrix of these strings to print later.
    final String[][] sts = new String[m.length][];
    int max_length = 0;  // Safe, since all lengths are positive here.
    for (int im = 0; im < m.length; im++) {
      sts[im] = new String[m[im].length];
      for (int jm = 0; jm < m[im].length; jm++) {
        final String st = String.valueOf(m[im][jm]);
        if (st.length() > max_length) {
          max_length = st.length();
        }
        sts[im][jm] = st;
      }
    }

    // Now max_length holds the length of the longest string.
    // Build a format string to right justify the strings in a field
    // of this length.
    final String format = String.format("%%%ds", max_length);
    for (int im = 0; im < m.length; im++) {
      System.out.print("|");
      // Stop one short to avoid a trailing space.
      for (int jm = 0; jm < m[im].length - 1; jm++) {
        System.out.format(format, m[im][jm]);
        System.out.print(" ");
      }
      System.out.format(format, m[im][m[im].length - 1]);
      System.out.println("|");
    }
  }

  /**
   * Run a test by printing the arguments, computing their
   * Kronecker product, and printing it.
   * @param a The first matrix to multiply.
   * @param b The second matrix to multiply.
   */
  private static void test(final int[][] a, final int[][] b) {
    // Print out matrices and their product.
    System.out.println("Testing Kronecker product");
    System.out.println("Size of matrix a: " + a.length + " by " + a[0].length);
    System.out.println("Matrix a:");
    print_matrix(a);
    System.out.println("Size of matrix b: " + b.length + " by " + b[0].length);
    System.out.println("Matrix b:");
    print_matrix(b);
    System.out.println("Calculating matrix c as Kronecker product");
    final int[][] c = product(a, b);
    System.out.println("Size of matrix c: " + c.length + " by " + c[0].length);
    System.out.println("Matrix c:");
    print_matrix(c);
  }

  /**
   * Create the matrices for the first test and run the test.
   */
  private static void test1() {
    // Test 1: Create a and b.
    final int[][] a = new int[2][];  // 2 by 2
    a[0] = new int[]{1, 2};
    a[1] = new int[]{3, 4};
    final int[][] b = new int[2][];  // 2 by 2
    b[0] = new int[]{0, 5};
    b[1] = new int[]{6, 7};
    // Run the test.
    test(a, b);
  }

  /**
   * Create the matrices for the first test and run the test.
   */
  private static void test2() {
    // Test 2: Create a and b.
    final int[][] a = new int[3][];  // 3 by 3
    a[0] = new int[]{0, 1, 0};
    a[1] = new int[]{1, 1, 1};
    a[2] = new int[]{0, 1, 0};
    final int[][] b = new int[3][];  // 3 by 4
    b[0] = new int[]{1, 1, 1, 1};
    b[1] = new int[]{1, 0, 0, 1};
    b[2] = new int[]{1, 1, 1, 1};
    // Run the test.
    test(a, b);
  }

  /**
   * Run the program to run the two tests.
   * @param args Command line arguments (not used).
   */
  public static void main(final String[] args) {
    // Test the product method.
    test1();
    test2();
  }

}

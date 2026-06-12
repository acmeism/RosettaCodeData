import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class PfaffianAndHfaffian {

	public static void main(String[] args) {
		List<int[][]> matrices = List.of(
			new int[][] { {  0, 1 },
						  { -1, 0 } }, // Tiny 2 x 2 matrix				
			
            new int[][] { {  0,  1, -1,  2 }, // Small 4 x 4 matrix
            			  { -1,  0,  3, -4 },
            			  {  1, -3,  0,  5 },
            			  { -2,  4, -5,  0 } },

            new int[][] { { 1,  2,  3,  4,  5,  6 }, // Symmetric 6 x 6 matrix
            			  { 2,  7,  8,  9, 10, 11 },
            			  { 3,  8, 12, 13, 14, 15 },
            			  { 4,  9, 13, 16, 17, 18 },
            			  { 5, 10, 14, 17, 19, 20 },
            			  { 6, 11, 15, 18, 20, 21 } },

            new int[][] { {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9 }, // Larger 10 x 10 matrix
                          { -1,  0,  8,  7,  6,  5,  4,  3,  2,  1 },
                          { -2, -8,  0,  1,  2,  3,  4,  5,  6,  7 },
                          { -3, -7, -1,  0,  6,  5,  4,  3,  2,  1 },
                          { -4, -6, -2, -6,  0,  1,  2,  3,  4,  5 },
                          { -5, -5, -3, -5, -1,  0,  4,  3,  2,  1 },
                          { -6, -4, -4, -4, -2, -4,  0,  1,  2,  3 },
                          { -7, -3, -5, -3, -3, -3, -1,  0,  2,  1 },
                          { -8, -2, -6, -2, -4, -2, -2, -2,  0,  1 },
                          { -9, -1, -7, -1, -5, -1, -3, -1, -1,  0 } }            			
        );
		
		matrices.stream().forEach( matrix -> {
			printMatrix(matrix);
			for ( Faffian faffian : Faffian.values() ) {
				Optional<Long> result = computeFaffian(matrix, faffian);
				if ( result.isPresent() ) {
					System.out.println(faffian + ": %d".formatted(result.get()));
				}
			}
			System.out.println();
		} );
	}
	
	private static Optional<Long> computeFaffian(int[][] matrix, Faffian faffian) {
		if ( matrix.length % 2 != 0 ) {
	        System.out.println("Matrix size must be even for " + faffian);
	        return Optional.empty();
	    }
		
		if ( ! isAntisymmetric(matrix) ) {
	        System.out.println("The " + faffian + " does not support non-antisymmetric matrices");
	        return Optional.empty();
	    }		
		
	    final int n = matrix.length / 2;
	    int sum = 0;
	    List<SignedPerm> signedPerms = signedPermutations(2 * n - 1);
	    for ( SignedPerm signedPerm : signedPerms ) {
	        List<Integer> sigma = signedPerm.permutation; 	
	        final int sign = ( faffian == Faffian.Pfaffian ) ? signedPerm.sign : 1;
	        int product = 1;
	        for ( int i = 0; i < n; i++ ) {
	            product *= matrix[sigma.get(2 * i)][sigma.get(2 * i + 1)];
	        }	
	        sum += sign * product;
	    }
	
	    final double normalisation = 1.0 / factorial(n) / Math.pow(2, n);
	    return Optional.of(Math.round(sum * normalisation));
	}
	
	private static List<SignedPerm> signedPermutations(int n) {
		List<Integer> perms = Stream.iterate(0, i -> i + 1 ).limit(n + 1).collect(Collectors.toList());
		List<SignedPerm> signedPerms =
			Stream.of( new SignedPerm( new ArrayList<Integer>(perms), 1) ).collect(Collectors.toList());		
	    int sign = 1;
	    for ( int k = 1; k < factorial(n + 1); k++ ) {
	        int i = n - 1;
	        int j = n;
	        while ( perms.get(i) > perms.get(i + 1) ) {
	        	i -= 1;
	        }
	        while ( perms.get(j) < perms.get(i) ) {
	        	j -= 1;
	        }
	        swap(perms, i, j);
	        sign = -sign;
	        i += 1;
	        j = n;
	        while ( i < j ) {
	            swap(perms, i, j);
	            sign = -sign;
	            i += 1;
	            j -= 1;
	        }
	        signedPerms.addLast( new SignedPerm( new ArrayList<Integer>(perms), sign) );
	    }
	    return signedPerms;
	}
	
	private static boolean isAntisymmetric(int[][] matrix) {
	    for ( int i = 0; i < matrix.length; i++ ) {
	        if ( matrix[i][i] != 0 ) {
	        	return false;
	        }	
	        for ( int j = i + 1; j < matrix.length; j++ ) {
	        	if ( matrix[i][j] != -matrix[j][i] ) {
	        		return false;
	        	}
	        }
	    }
	    return true;
	}
	
	private static int factorial(int n) {
		int factorial = 1;
		for ( int i = 2; i <= n; i++ ) {
			factorial *= i;
		}
		return factorial;
	}
	
	private static void swap(List<Integer> list, int i, int j) {
		final int temp = list.get(i);
		list.set(i, list.get(j));
		list.set(j, temp);
	}
	
	private static void printMatrix(int[][] matrix) {
		for ( int[] row : matrix ) {
			System.out.print("|");
			for ( int i = 0; i < row.length - 1; i++ ) {
				System.out.print("%2d, ".formatted(row[i]));
			}
			System.out.println("%2d|".formatted(row[row.length - 1]));
		}				
	}
	
	private static record SignedPerm(List<Integer> permutation, int sign) {}

	private static enum Faffian { Pfaffian, Hfaffian };

}

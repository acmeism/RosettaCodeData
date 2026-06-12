import java.util.stream.IntStream;

public final class ResistanceNetworkCalculation {

	public static void main() {
		IO.println(network(7, 0, 1, "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8"));
		IO.println(network(9, 0, 8, "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1"));
		IO.println(network(16, 0, 15, "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|"
			+ "13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1"));
		IO.println(network(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250"));
	}
	
	private static Rational network(int n, int k0, int k1, String text) {
		Rational[][] matrix = IntStream.range(0, n)
			.mapToObj( i -> IntStream.range(0, n + 1).mapToObj( j -> new Rational(0, 1) )
			.toArray(Rational[]::new) ).toArray(Rational[][]::new);
		
		for ( String resistor : text.split("\\|") ) { // Escape '|' character,			
			String[] abr = resistor.split(" ");       // because it is a special character in regex
			final int a = Integer.parseInt(abr[0]);
			final int b = Integer.parseInt(abr[1]);
			Rational r = new Rational(1, Integer.parseInt(abr[2]));
			
			matrix[a][a] = matrix[a][a].add(r);
			matrix[b][b] = matrix[b][b].add(r);
			
			if ( a > 0 ) {
				matrix[a][b] = matrix[a][b].subtract(r);
			}
			if ( b > 0 ) {
				matrix[b][a] = matrix[b][a].subtract(r);;
			}
		}
		
		matrix[k0][k0] = new Rational(1, 1);
		matrix[k1][n] = new Rational(1, 1);
		
		return gauss(matrix)[k1];
	}
	
	private static Rational[] gauss(Rational[][] matrix) {
		final int rowCount = matrix.length;
		final int colCount = matrix[0].length;
		
		for ( int row = 0; row < rowCount; row++ ) {
			final int r = row;
			final int maxIndex = IntStream.range(row, rowCount).reduce( (x, y) ->
				( Math.abs(matrix[y][r].value()) > Math.abs(matrix[x][r].value()) ) ? y : x ).getAsInt();

			Rational[] temp = matrix[row];
			matrix[row] = matrix[maxIndex];
			matrix[maxIndex] = temp;
			
			Rational inverse = new Rational(matrix[row][row].denom(), matrix[row][row].numer());		
			for ( int j = row + 1; j < colCount; j++ ) {
				matrix[row][j] = matrix[row][j].multiply(inverse);
			}
			
			for ( int j = row + 1; j < rowCount; j++ ) {
				inverse = matrix[j][row];				
				for ( int k = row + 1; k < colCount; k++ ) {
					matrix[j][k] = matrix[j][k].subtract(inverse.multiply(matrix[row][k]));
				}
			}
		}
		
		for ( int i = rowCount - 1; i > 0; i-- ) {
			for ( int j = 0; j < i; j++ ) {
				matrix[j][colCount - 1] =
					matrix[j][colCount - 1].subtract(matrix[j][i].multiply(matrix[i][colCount - 1]));
			}
		}

		return IntStream.range(0, rowCount).mapToObj( row -> matrix[row][colCount - 1] ).toArray(Rational[]::new);
	}

	private static final class Rational {
		
		public Rational(long aNumer, long aDenom) {
			final long gcd = gcd(aNumer, aDenom);
			numer = aNumer / gcd;
			denom = aDenom / gcd;
		}
		
		public Rational add(Rational other) {
			return new Rational(numer * other.denom + other.numer * denom, denom * other.denom);
		}
		
		public Rational subtract(Rational other) {
			return new Rational(numer * other.denom - other.numer * denom, denom * other.denom);
		}
		
		public Rational multiply(Rational other) {
			return new Rational(numer * other.numer, denom * other.denom);
		}
		
		public double value() {
			return (double) numer / denom;
		}
		
		public long numer() {
			return numer;
		}
		
		public long denom() {
			return denom;
		}
		
		@Override
		public String toString() {
			return numer + " / " + denom;
		}
		
		private long gcd(long a, long b) {
			return ( b == 0 ) ? a : gcd(b, a % b);
		}
		
		private final long numer;
		private final long denom;
		
	}

}

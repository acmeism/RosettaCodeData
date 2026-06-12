import java.util.stream.IntStream;

public final class SteadySquares {

	public static void main(String[] args) {
		IntStream.range(1, 10_000).forEach( n -> {
			String strN = String.valueOf(n);
			String squared = String.valueOf(n * n);
			if ( strN.equals(squared.substring(squared.length() - strN.length())) ) {
				System.out.println(strN + "^2 = " + squared);
			}		
		} );
	}

}

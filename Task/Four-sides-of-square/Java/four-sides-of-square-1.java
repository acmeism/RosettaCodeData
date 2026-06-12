import java.util.stream.IntStream;

public final class FourSideOfASquareText {

	public static void main(String[] args) {
		final int squareSize = 6;
		IntStream.range(0, squareSize).forEach( x -> {
	        IntStream.range(0, squareSize).forEach( y -> {
	            System.out.print((x == 0 || x == squareSize - 1 || y == 0 || y == squareSize - 1 ) ? "1 " : "0 ");
	        } );
	        System.out.println();
	    } );
	}

}

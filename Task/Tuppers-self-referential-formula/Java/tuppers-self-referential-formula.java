import java.io.IOException;
import java.io.PrintStream;
import java.math.BigInteger;
import java.util.Arrays;

public final class TuppersSelfReferentialFormula {

	public static void main(String[] args) throws IOException {
		boolean[][] matrix = tuppersMatrix();
		
		PrintStream writer = new PrintStream(System.out, true, "UTF-8");
		writer.println("\033[45m"); // Magenta background
	    for ( int row = 0; row < 17; row++ ) {
	        for ( int column = 0; column < 106; column++ ) {
	        	String character = matrix[row][column] ? "\u2588" : " ";
	        	writer.print(character);
	        }
	        writer.println();
		 }
	    writer.close();
	}
	
	private static boolean[][] tuppersMatrix() {
	    boolean[][] matrix = new boolean[17][106];
	    Arrays.stream(matrix).forEach( row -> Arrays.fill(row, true) );	
	    final BigInteger seventeen = BigInteger.valueOf(17);
	
	    for ( int column = 0; column < 106; column++ ) {
	        for ( int row = 0; row < 17; row++ ) {
	            BigInteger y = k.add(BigInteger.valueOf(row));
	            BigInteger a = y.divideAndRemainder(seventeen)[0];
	            int bb = y.mod(seventeen).intValueExact();
	            bb += column * 17;	
	            BigInteger b = BigInteger.TWO.pow(bb);
	            a = a.divideAndRemainder(b)[0];
	            int aa = a.mod(BigInteger.TWO).intValueExact();	
	            matrix[row][105 - column] = ( aa == 1 );
	        }
	    }
	    return matrix;
	}
	
	private static final BigInteger k = new BigInteger("960939379918958884971672962127852754715"
		+ "004339660129306651505519271702802395266424689642842174350718121267153782"
		+ "770623355993237280874144307891325963941337723487857735749823926629715517"
		+ "173716995165232890538221612403238855866184013235585136048828693337902491"
		+ "454229288667081096184496091705183454067827731551705405381627380967602565"
		+ "625016981482083418783163849115590225610003652351370343874461848378737238"
		+ "198224849863465033159410054974700593138339226497249461751545728366702369"
		+ "745461014655997933798537483143786841806593422227898388722980000748404719");
	
}

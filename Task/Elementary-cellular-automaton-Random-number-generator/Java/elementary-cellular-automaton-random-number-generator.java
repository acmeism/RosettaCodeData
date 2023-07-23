public class ElementaryCellularAutomatonRandomNumberGenerator {

	public static void main(String[] aArgs) {
		final int seed = 989898989;
		evolve(seed, 30);
	}
	
	private static void evolve(int aState, int aRule) {
		long state = aState;
	    for ( int i = 0; i <= 9; i++ ) {
	        int b = 0;
	        for ( int q = 7; q >= 0; q-- ) {
	            long stateCopy = state;
	            b |= ( stateCopy & 1 ) << q;
	            state = 0;
	            for ( int j = 0; j < BIT_COUNT; j++ ) {
	                long t = ( stateCopy >>> ( j - 1 ) ) | ( stateCopy << ( BIT_COUNT + 1 - j ) ) & 7;
	                if ( ( aRule & ( 1L << t ) ) != 0 ) {
	                	state |= 1 << j;
	                }
	            }
	        }
	        System.out.print(" " + b);
	    }
	    System.out.println();
	}
	
	private static final int BIT_COUNT = 64;

}

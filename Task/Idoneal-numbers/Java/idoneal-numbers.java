import java.util.Arrays;

public final class IdonealNumbers {

	public static void main(String[] args) {
		final int N = 2_000;
		boolean[] idoneal = new boolean[N];
		Arrays.fill(idoneal, true);
		
		for ( int a = 1; a < Math.sqrt(N / 3); a++ ) {
			int p = a * ( a + 1 );
		    for ( int b = a + 1; b < N / ( 3 * a ); b++ ) {
		    	int n = p + ( a + b ) * ( b + 1 );
		        while ( n < N ) {	
		        	idoneal[n] = false;
		        	n += a + b;
		        }
		        p += a;
		    }
		}		
		
		for ( int i = 1, count = 0; i < N; i++ ) {
		    if ( idoneal[i] ) {
		        count += 1;
		        System.out.print(String.format("%5d%s", i, ( ( count % 13 == 0 ) ? "\n" : "" )));
		    }
		}		
	}
	
}

import java.math.BigInteger;

public final class SmallestPowerOf6WhoseDecimalExpansionContainsN {

	public static void main(String[] args) {		
		System.out.println(" n  smallest power of 6 which contains n");
		BigInteger six = BigInteger.valueOf(6);		
		for ( int n = 0; n <= 21; n++ ) {
			String textN = String.valueOf(n);
			String pow6 = BigInteger.ONE.toString();
		    int i = 0;
		    while ( ! pow6.contains(textN) ) {
		    	i += 1;
		        pow6 = six.pow(i).toString();
		    }
		    System.out.println("%2s:  6^%-2d = %s".formatted(textN, i, pow6));
		}
	}

}

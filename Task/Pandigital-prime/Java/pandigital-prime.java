public final class PandigitalPrime {	
	
	public static void main(String[] args) {
		pandigitalPrime('1');
		pandigitalPrime('0');
	}
	
	private static void pandigitalPrime(char n) {
		final int start = ( n == '1' ) ? 7654321 : 76543201;
		int test = start + 18;
		boolean searching = true;
		
		while ( searching ) {
			test -= 18;
			String value = String.valueOf(test);
			boolean pandigital = true;
			for ( char ch = n; ch <= '7' && pandigital; ch++ ) {
				if ( value.indexOf(ch) < 0 ) {
					pandigital = false;
		    	}
		    }
			
			if ( ! pandigital ) {
				continue;
			}
			
			if ( test % 3 == 0 ) {
		    	continue;
		    }
			
			int divisor = 1;
			boolean divisible = false;			
			while ( divisor * divisor < test ) {
				if ( test % ( divisor += 4 ) == 0 || test % ( divisor += 2 ) == 0 ) {
		        	divisible = true;
		        }
		    }
			
			if ( divisible ) {
				continue;
			}
			
			searching = false;
			String suffix = ( n == '1' ) ? "" : "0";
			System.out.println("The largest pandigital" + suffix + " prime is: " + test);			
		}	
	}
	
}

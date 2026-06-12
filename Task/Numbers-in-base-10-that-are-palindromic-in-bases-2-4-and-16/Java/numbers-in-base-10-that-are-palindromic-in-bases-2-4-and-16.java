import module java.base;

public final class NumbersInBase10ThatArePalindromicInBases2416 {

	public static void main() {	
		BiPredicate<Integer, Integer> isPalindromicInBase = (n, b) -> {
			String inBase = BigInteger.valueOf(n).toString(b);
			return inBase.equals( new StringBuilder(inBase).reverse().toString() );
		};
		
		IntStream.range(0, 25_000).forEach( n -> {
			if ( Stream.of( 2, 4, 16 ).allMatch( base -> isPalindromicInBase.test(n, base) ) ) {
				IO.print(n + " ");
			}
		} );
        IO.println();
	}

}

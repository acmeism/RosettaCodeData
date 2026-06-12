import java.util.List;

public final class UpsideDownNumbers {

	public static void main(String[] args) {
		System.out.println("The first 50 upside-down numbers:");
		for ( int i = 1; i <= 50; i++ ) {
			System.out.print(String.format("%4s%s", indexedUDNumber(i), ( i % 10  == 0 ) ? "\n" : " " ));
		}
		System.out.println();
		
		List<Long> indexes = List.of(
			50_000L, 500_000L, 5_000_000L, 5_000_000_000L, 5_000_000_000_000L, 5_000_000_000_000_000L );
		indexes.forEach( index ->
			System.out.println("The " + index + "th upside-down number is " + indexedUDNumber(index)));
	}
	
	private static String indexedUDNumber(long index) {
		int digitCount = 1;
	    long first = 1, last = 1, lastIndex = 1;
	    while ( index > last ) {
	        first = last + 1;
	        digitCount += 1;
	        if ( digitCount % 2 == 0 ) {
	        	lastIndex *= 9;
	        }
	        last = first + lastIndex - 1;
	    }
	    return nextDigits(index - first + 1, digitCount, lastIndex);	
	}
	
	private static String nextDigits(long firstIndex, int digitCount, long lastIndex) {
		if ( digitCount <= 1 ) {
			return "5".repeat(digitCount);
		}
	
	    lastIndex /= 9;
	    final long d = ( firstIndex - 1 ) / lastIndex;
	    firstIndex -= d * lastIndex;
	    return String.valueOf(1 + d) + nextDigits(firstIndex, digitCount - 2, lastIndex)
            + String.valueOf(9 - d);
	}

}

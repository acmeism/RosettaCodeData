import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

public final class DividuusNumbers {

	public static void main(String[] args) {
		Function<Long, Long> sumOfDigits = n ->
			(long) String.valueOf(n).chars().map(Character::getNumericValue).sum();
			
		Function<Long, Long> productOfDigits = n ->
			(long) String.valueOf(n).chars().map(Character::getNumericValue).reduce( (a, b) -> a * b ).getAsInt();
			
		Function<Long, Long> digitalRoot = n -> 1 + ( n - 1 ) % 9;
			
		Function<Long, Long> multiplicativeDigitalRoot = n -> {
			do {
				n = productOfDigits.apply(n);
			} while ( n >= 10 );
			return n;
		};
		
		Predicate<Long> isDividuus = n -> digitalRoot.apply(n) != 0 && multiplicativeDigitalRoot.apply(n) != 0
			&& n % sumOfDigits.apply(n) == 0 && n % productOfDigits.apply(n) == 0 && n % digitalRoot.apply(n) == 0
			&& n % multiplicativeDigitalRoot.apply(n) == 0;
		
		List<Long> dividuus = new ArrayList<Long>();
		long number = 1;
	    while ( dividuus.size() < 50 ) {
	        if ( isDividuus.test(number) ) {
	            dividuus.addLast(number);
	        }
	        number += 1;
	    }
		
	    System.out.println("The first 50 dividuus numbers:");
	    IntStream.range(0, dividuus.size()).forEach( i -> {
	    	System.out.print("%5d%s".formatted(dividuus.get(i), ( i % 10 == 9 ? "\n" : " " )));
	    } );
		
	    dividuus.clear();
	    LongStream.rangeClosed(990_000_000, 1_000_000_000).forEach( i -> {
	        if ( isDividuus.test(i) ) {
	            dividuus.addLast(i);
	        }
	    } );
	
	    System.out.println("\nDividuus numbers between 990,000,000 and 1,000,000,000: " + dividuus);
	}

}

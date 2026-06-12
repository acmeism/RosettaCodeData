import java.util.stream.IntStream;

public final class PalindromicPrimes {

	public static void main(String[] args) {	
		IntStream.range(2, 1_000)
			.filter( i -> IntStream.range(2, i).noneMatch( p -> i % p == 0 ) )
			.mapToObj(Integer::toString)
			.filter( s -> s.equals( new StringBuilder(s).reverse().toString() ) )
			.forEach( s -> System.out.print(s + " ") );
	}	

}

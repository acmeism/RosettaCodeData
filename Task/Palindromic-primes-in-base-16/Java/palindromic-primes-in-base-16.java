import java.util.stream.IntStream;

public final class PalindromicPrimesInBase16 {

	public static void main(String[] args) {	
		IntStream.range(2, 500).filter( i -> IntStream.range(2, i).noneMatch( p -> i % p == 0 ) )
							   .mapToObj(Integer::toHexString)
							   .filter( s -> s.equals( new StringBuilder(s).reverse().toString() ) )
							   .forEach( s -> System.out.print(s + " ") );
	}	

}


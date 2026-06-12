import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.stream.Collectors;

public final class DistinctPalindromesWithinDecimalNumbers {

	public static void main(String[] args) {
		System.out.println("Number  Palindromes");
		for ( int i = 100; i <= 125; i++ ) {
			System.out.print(i + "  ");	
			allPalindromes(String.valueOf(i)).forEach( palindrome -> 						
				System.out.print(String.format("%5s", palindrome)) );
		    System.out.println();	
		}
		
		List<String> numbers = List.of( "9", "169", "12769", "1238769", "123498769", "12346098769",
	    	"1234572098769", "123456832098769", "12345679432098769", "1234567905432098769",
	    	"123456790165432098769", "83071934127905179083", "1320267947849490361205695" );
	
	    System.out.println("\nNumber            Has no >= 2 digit palindromes");
	    numbers.forEach( number -> {
	    	boolean none = allPalindromes(String.valueOf(number)).stream().noneMatch( s -> s.length() > 1 );
	    	System.out.println(String.format("%-26s%1s", number, none));
	    } );
	}
	
	private static Set<String> allPalindromes(String number) {
	    List<String> substrings = new ArrayList<String>();
	    for ( int i = 0; i < number.length(); i++ ) {
	        for ( int j = 1; j <= number.length() - i; j++ ) {
	        	substrings.addLast(number.substring(i, i + j));
	        }
	    }
	
	    return substrings.stream()
	    	.filter( s -> s.equals( new StringBuilder(s).reverse().toString() ) )
            .collect(Collectors.toCollection(TreeSet::new));
	}

}

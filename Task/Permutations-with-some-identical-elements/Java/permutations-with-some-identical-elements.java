import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class PermutationsWithSomeIdenticalElements {
	
	public static void main(String[] args) {
		System.out.println(findPermutations("121"));
		
		List<String> permutations = findPermutations("BACBAB");
		IntStream.range(0, permutations.size()).forEach( i -> {
			System.out.print("%s%s".formatted(permutations.get(i), ( i % 10 == 9 ? "\n" : " ")));
		} );
     }
	
    private static List<String> findPermutations(String text) {
    	String sorted = Stream.of(text.split("")).sorted().collect(Collectors.joining(""));
    	
        ArrayList<String> result = new ArrayList<String>();
        recursivePermute(sorted.toCharArray(), 0, result);
        return result;
    }

    private static void recursivePermute(char[] permutation, int index, List<String> result) {
    	if ( index == permutation.length ) {
			result.addLast( new String(permutation) );
			return;
		}
    	
    	IntStream.range(index, permutation.length).forEach( i -> {
	        if ( isValidSwap(permutation, index, i) ) {
	        	swap(permutation, index, i);
	            recursivePermute(permutation, index + 1, result);
	            swap(permutation, index, i);
	        }
	    } );
	}

    private static boolean isValidSwap(char[] permutation, int start, int current) {
    	return IntStream.range(start, current).allMatch( i -> permutation[i] != permutation[current] );
    }

    private static void swap(char[] permutation, int i, int j) {
    	final char temp = permutation[i];
    	permutation[i] = permutation[j];
    	permutation[j] = temp;
    }

}

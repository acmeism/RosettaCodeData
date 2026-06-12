import module java.base;

public final class PrimeGroups {

	public static void main() {
		 List<String> words = List.of( "riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja" );
		 IO.println("Three character prime groups: " + primeGroups(words, 3));
		 IO.println("Two character prime groups: " + primeGroups(words, 2));
	}
	
	private static List<String> primeGroups(List<String> words, int size) {
	    List<String> result = new ArrayList<String>();
	    for ( String word : words ) {
	    	String found = "Not found";
	        List<Character> chars = word.chars().mapToObj( i -> (char) i ).toList();
	
	        for ( List<Character> combo : combinations(chars, size) ) {
	        	if ( IntStream.range(0, size).allMatch( i ->
	        		IntStream.range(i + 1, size).allMatch( j ->
	        			isPrime.test(Math.abs(combo.get(i) - combo.get(j))) ) ) ) {
	        		found = combo.stream().map(String::valueOf).collect(Collectors.joining());
	        		break;
	        	}
	        }	
	        result.addLast(found);
	    }	
	    return result;
	}
	
	private static <T> List<List<T>> combinations(List<T> list, int choose) {
		List<List<T>> combinations = new ArrayList<List<T>>();
	    List<Integer> combination = IntStream.range(0, choose).boxed().collect(Collectors.toList());	
	    while ( combination.get(choose - 1) < list.size() ) {   	
	        combinations.add(combination.stream().map( i -> list.get(i) ).toList());	
	        int temp = choose - 1;
	        while ( temp != 0 && combination.get(temp) == list.size() - choose + temp ) {
	            temp -= 1;
	        }
	        combination.set(temp, combination.get(temp) + 1);
	        for ( int i = temp + 1; i < choose; i++ ) {
	        	combination.set(i, combination.get(i - 1) + 1);
	        }
	    }	
	    return combinations;
	}
	
	private static Predicate<Integer> isPrime = p -> p > 1 &&
		IntStream.rangeClosed(2, (int) Math.sqrt(p)).noneMatch( i -> p % i == 0 );

}

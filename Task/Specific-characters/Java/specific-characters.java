import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class SpecificCharacters {

	public static void main(String[] args) {
		System.out.println(specificCharacters(List.of( "ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr" )));		
	}
	
	private static List<List<Integer>> specificCharacters(List<String> strings) {
	    final int stringCount = strings.size();
	    List<Integer> resultOne = Stream.generate( () -> 0 ).limit(stringCount).collect(Collectors.toList());
	    List<Integer> uniques = Stream.generate( () -> 0 ).limit(stringCount).collect(Collectors.toList());
	    IntStream.range(0, stringCount).forEach( i -> {
	        Map<Character, Integer> charCounts = strings.get(i).chars().mapToObj( ch -> (char) ch )
	        	.collect(Collectors.toMap( k -> k, v -> 1, Integer::sum ));
	        uniques.set(i, charCounts.size());
	        int specificCharCount = 0;
	        for ( Map.Entry<Character, Integer> entry : charCounts.entrySet() ) {
	        	if ( entry.getValue() != 2 ) {
	        		continue;
	        	}
	        	
                boolean inOtherString = false;
                for ( int j = 0; j < stringCount; j++ ) {
                    if ( i != j && strings.get(j).indexOf(entry.getKey()) >= 0 ) {
                        inOtherString = true;
                        break;
                    }
                }
                if ( ! inOtherString ) {
                	specificCharCount += 1;
                }
	        }
	        resultOne.set(i, specificCharCount);
	    } );
	
	    List<Integer> resultTwo = IntStream.range(0, stringCount)
	    	.map( i -> uniques.get(i) - resultOne.get(i) ).boxed().toList();
	    return List.of( resultOne, resultTwo );
	}

}

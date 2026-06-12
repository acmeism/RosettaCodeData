import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public final class Ngrams {

	public static void main(String[] args) {
		final String text = "Live and let live".toUpperCase();
		for ( int letterCount : List.of( 2, 3, 4 ) ) {
			Map<String, Integer> ngrams = findNgrams(text, letterCount);		
			System.out.println("All " + letterCount + "-grams of " + text + " and their frequencies:");
			for ( Map.Entry<String, Integer> entry : ngrams.entrySet() ) {
				System.out.println("(\"" + entry.getKey() + "\" : " + entry.getValue() + ")");
			}
			System.out.println();
		}
	}	
	
	private static Map<String, Integer> findNgrams(String text, int letterCount) {
	    Map<String, Integer> ngrams = new HashMap<String, Integer>();
	    for ( int i = 0; i <= text.length() - letterCount; i++ ) {
	        String ngram = text.substring(i, i + letterCount);
	        ngrams.merge(ngram, 1, Integer::sum);
	    }	
	    return sort(ngrams);
	}
	
	private static Map<String, Integer> sort(Map<String, Integer> map) {
		return map.entrySet().stream().sorted( (one, two) -> {
			final int comparison = two.getValue().compareTo(one.getValue());
			return ( comparison == 0 ) ? one.getKey().compareTo(two.getKey()) : comparison;
		} ).collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue,
		       (oldValue, newValue) -> oldValue, LinkedHashMap::new));
	}

}

import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public final class MostFrequentKCharsDistance {

	public static void main(String[] args) {
		record Pair(String first, String second) {}
		
		List<Pair> pairs = List.of( new Pair("night", "nacht"), new Pair("my", "a"),
			new Pair("research", "research"), new Pair("significant", "capabilities"),
			new Pair("LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV",
					 "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG") );
		
		for ( Pair pair : pairs ) {			
			System.out.print(pair.first + ", " + pair.second + " -> ");
			System.out.print(mostFrequent(pair.first, 2) + ", " + mostFrequent(pair.second, 2) + " -> ");
			final int maximum = ( pair.first.length() < 20 ) ? 10 : 100;
			System.out.println(mostFrequentKSDF(pair.first, pair.second, 2, maximum));
		}
	}
	
	private static int mostFrequentKSDF(String text1, String text2, int limit, int maximum) {
		return maximum - mostFrequentKsimilarity(text1, text2, limit);
	}
	
	private static int mostFrequentKsimilarity(String text1, String text2, int limit) {
	    int similarity = 0;
	    Map<Character, Integer> mostFrequent1 = mostFrequent(text1, limit);
	    Map<Character, Integer> mostFrequent2 = mostFrequent(text2, limit);
	    for ( Character ch : mostFrequent1.keySet() ) {
	        if ( mostFrequent2.containsKey(ch) ) {
	        	similarity += mostFrequent1.get(ch) + mostFrequent2.get(ch);
	        }
	    }
	    return similarity;
	}
	
	private static Map<Character, Integer> mostFrequent(String text, int limit) {
		Map<Character, Integer> charCount = text.chars().boxed().collect(
			Collectors.toMap(k -> (char) k.intValue(), v -> 1, Integer::sum, LinkedHashMap::new));
		
		return charCount.entrySet().stream().sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
	        .limit(limit).collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue,
	            (oldValue, newValue) -> oldValue, LinkedHashMap::new));
	}

}

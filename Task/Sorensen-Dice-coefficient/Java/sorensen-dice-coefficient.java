import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class SorensenDiceCoefficient {

	public static void main(String[] args) throws IOException {
		List<String> tasks = Files.readAllLines(Path.of("Rosetta Code Tasks.dat"), StandardCharsets.UTF_8);
		
		List<String> tests = List.of(
			"Primordial primes", "Sunkist-Giuliani formula", "Sieve of Euripides", "Chowder numbers" );	
		
		record TaskValue(String task, double value) {}
			
		for ( String test : tests ) {
			List<TaskValue> taskValues = new ArrayList<TaskValue>();	
			Map<String, Integer> bigramsTest = createBigrams(test);
			for ( String task : tasks ) {
				double value = sorensenDice(bigramsTest, createBigrams(task));
				taskValues.add( new TaskValue(task, value) );
			}
			
			Collections.sort(taskValues, (one, two) -> Double.compare(two.value, one.value));
						
			System.out.println(test + ":");
			for ( int i = 0; i < 5; i++ ) {
				System.out.println(String.format("%s%.4f%s%s",
					"    ", taskValues.get(i).value, " ", taskValues.get(i).task));
			}
			System.out.println();
		}
	}
	
	private static double sorensenDice(Map<String, Integer> bigramsOne, Map<String, Integer> bigramsTwo) {
		int intersectionSize = 0;
		for ( Map.Entry<String, Integer> entry : bigramsOne.entrySet() ) {
			if ( bigramsTwo.keySet().contains(entry.getKey()) ) {
				intersectionSize += Math.min(entry.getValue(), bigramsTwo.get(entry.getKey()));
			}
		}	
	    return 2.0 * intersectionSize / ( size(bigramsOne) + size(bigramsTwo) );
	}
	
	private static Map<String, Integer> createBigrams(String text) {
		Map<String, Integer> result = new HashMap<String, Integer>();
		for ( String word : text.toLowerCase().split(" ") ) {
			if ( word.length() == 1 ) {
				result.merge(word, 1, Integer::sum);
			} else {
				for ( int i = 0; i < word.length() - 1; i++ ) {
					result.merge(word.substring(i, i + 2), 1, Integer::sum);
				}
			}
		}
		return result;
	}
	
	private static int size(Map<String, Integer> map) {
		return map.values().stream().mapToInt(Integer::intValue).sum();
	}

}

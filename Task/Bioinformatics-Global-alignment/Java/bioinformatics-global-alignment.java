import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public final class BioinformaticsGlobalAlignment {

	public static void main(String[] aArgs) {
		List<List<String>> testSequences = Arrays.asList(
			Arrays.asList( "TA", "AAG", "TA", "GAA", "TA" ),
			Arrays.asList( "CATTAGGG", "ATTAG", "GGG", "TA" ),
			Arrays.asList( "AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA" ),
			Arrays.asList( "ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
				"GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT",
				"CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
				"TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
				"AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT",
				"GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC",
				"CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT",
				"TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
				"CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC",
				"GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT",
				"TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
				"CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
				"TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA" )
		);
		
		for ( List<String> test : testSequences ) {
			for ( String superstring : shortestCommonSuperstrings(test) ) {
				printReport(superstring);
			}
		}
	}
	
	// Return a set containing all of the shortest common superstrings of the given list of strings.
	private static Set<String> shortestCommonSuperstrings(List<String> aList) {
		List<String> deduplicated = deduplicate(aList);
		Set<String> shortest = new HashSet<String>();
		shortest.add(String.join("", deduplicated));
		int shortestLength = aList.stream().mapToInt( s -> s.length() ).sum();
			
		for ( List<String> permutation : permutations(deduplicated) ) {
			String candidate = permutation.stream().reduce("", (a, b) -> concatenate(a, b) );
	        if ( candidate.length() < shortestLength ) {
	            shortest.clear();
	            shortest.add(candidate);
	            shortestLength = candidate.length();
	        } else if ( candidate.length() == shortestLength ) {
	            shortest.add(candidate);
	        }
		}
		return shortest;		
	}

	// Remove duplicate strings and strings which are substrings of other strings in the given list.
	private static List<String> deduplicate(List<String> aList) {
		List<String> unique = aList.stream().distinct().collect(Collectors.toList());
		List<String> result = new ArrayList<String>(unique);
		List<String> markedForRemoval = new ArrayList<String>();
		for ( String testWord : result ) {
			for ( String word : unique ) {
				if ( ! word.equals(testWord) && word.contains(testWord) ) {
					markedForRemoval.add(testWord);
				}
			}
		}
		result.removeAll(markedForRemoval);
		return result;
	}	
	
	// Return aBefore concatenated with aAfter, removing the longest suffix of aBefore that matches a prefix of aAfter.
	private static String concatenate(String aBefore, String aAfter) {	
	    for ( int i = 0; i < aBefore.length(); i++ ) {
	        if ( aAfter.startsWith(aBefore.substring(i, aBefore.length())) ) {
	            return aBefore.substring(0, i) + aAfter;
	        }
	    }
	    return aBefore + aAfter;
	}
	
	// Return all permutations of the given list of strings.
	private static List<List<String>> permutations(List<String> aList) {
		int[] indexes = new int[aList.size()];
	    List<List<String>> result = new ArrayList<List<String>>();
	    result.add( new ArrayList<String>(aList) );
	    int i = 0;
		while ( i < aList.size() ) {
		    if ( indexes[i] < i ) {
		    	final int j = ( i % 2 == 0 ) ? 0 : indexes[i];
		    	String temp = aList.get(j);
		    	aList.set(j, aList.get(i));
		    	aList.set(i, temp);
		        result.add( new ArrayList<String>(aList) );
		        indexes[i]++;
		        i = 0;
		    } else {
		        indexes[i] = 0;
		        i += 1;
		    }
		}	
		return result;
	}
	
	// Print a report of the given string to the standard output device.
	private static void printReport(String aText) {
		char[] nucleotides = new char[] {'A', 'C', 'G', 'T' };
		Map<Character, Integer> bases = new HashMap<Character, Integer>();
		for ( char base : nucleotides ) {
			bases.put(base, 0);
		}
		
		for ( char ch : aText.toCharArray() ) {
			bases.merge(ch, 1, Integer::sum);
		}
		final int total = bases.values().stream().reduce(0, Integer::sum);
		
		System.out.print("Nucleotide counts for: " + ( ( aText.length() > 50 ) ? System.lineSeparator() : "") );
		System.out.println(aText);
		System.out.print(String.format("%s%d%s%d%s%d%s%d",
			"Bases: A: ", bases.get('A'), ", C: ", bases.get('C'), ", G: ", bases.get('G'), ", T: ", bases.get('T')));
		System.out.println(", total: " + total + System.lineSeparator());
	}

}

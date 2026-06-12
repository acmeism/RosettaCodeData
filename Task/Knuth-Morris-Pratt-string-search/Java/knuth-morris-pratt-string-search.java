import java.util.ArrayList;
import java.util.List;

public final class KnuthMorrisPrattAlgorithm {

	public static void main(String[] args) {
		List<String> texts = List.of(
		    "GCTAGCTCTACGAGTCTA",
		    "GGCTATAATGCGTA",
		    "there would have been a time for such a word",
		    "needle need noodle needle",
		    "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuth"
		    + "usesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages"
		    + "toillustratetheconceptsandalgorithmsastheyarepresented",
		    "Nearby farms grew a half acre of alfalfa on the dairy's behalf,"
		    + " with bales of all that alfalfa exchanged for milk."
		);
		
		List<String> patterns = List.of( "TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa" );
		
		for ( int i = 0; i < texts.size(); i++ ) {
			System.out.println("Text" + ( i + 1 ) + " = " + texts.get(i));
		}
		System.out.println();
		
		for ( int i = 0; i < patterns.size(); i++ ) {
			final int j = ( i < 5 ) ? i : i - 1;
			List<Integer> result = kmpSearch(patterns.get(i), texts.get(j));
			System.out.println("Found '" + patterns.get(i) + "' in 'Text" + ( j + 1 ) + "' at indices " + result);		
		}
	}
	
	private static List<Integer> kmpSearch(String pattern, String text) {
        List<Integer> result = new ArrayList<Integer>();
        int[] lps = constructLPS(pattern);

        int textIndex = 0;
        int patternIndex = 0;

        while ( textIndex < text.length() ) {
            if ( text.charAt(textIndex) == pattern.charAt(patternIndex) ) {
                textIndex += 1;
                patternIndex += 1;
                if ( patternIndex == pattern.length() ) {
                    result.add(textIndex - patternIndex);
                    patternIndex = lps[patternIndex - 1];
                }
            } else {
                if ( patternIndex != 0 ) {
                    patternIndex = lps[patternIndex - 1];
                } else {
                    textIndex += 1;
                }
            }
        }

        return result;
    }
	
	private static int[] constructLPS(String pattern) {
		int[] lps = new int[pattern.length()];
        int length = 0;
        int patternIndex = 1;

        while ( patternIndex < pattern.length() ) {
            if ( pattern.charAt(patternIndex) == pattern.charAt(length) ) {
                length += 1;
                lps[patternIndex] = length;
                patternIndex += 1;
            } else {
                if ( length != 0 ) {
                    length = lps[length - 1];
                } else {
                    lps[patternIndex] = 0;
                    patternIndex += 1;
                }
            }
        }

        return lps;
    }

}

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.Function;

public final class CountHowManyVowelsAndConsonantsOccurInAString {

	public static void main(String[] args) {
		String test = "Now is the time for all good men to come to the aid of their country.";
		Count letters = letterCount(test);
		System.out.println("\"" + test + "\"");
		System.out.println("contains " + letters.vowelTotal + " vowels (" + letters.vowelDistinct + " distinct)"
		   + " and " + letters.consonantTotal + " consonants (" + letters.consonantDistinct + " distinct)");
	}
	
	private static Count letterCount(String text) {
		Set<Character> vowelSet = new HashSet<Character>();
		Set<Character> consonantSet = new HashSet<Character>();
		int vowelTotal = 0;
		int consonantTotal = 0;
		for ( char ch : text.toCharArray() ) {
			if ( isVowel.apply(ch) ) {
				vowelTotal += 1;
				vowelSet.add(Character.toLowerCase(ch));
			}
			if ( isConsonant.apply(ch) ) {
				consonantTotal += 1;
				consonantSet.add(Character.toLowerCase(ch));
			}
		}
		return new Count(vowelTotal, vowelSet.size(), consonantTotal, consonantSet.size());
	}
	
	private static final List<Character> vowels = List.of( 'a', 'e', 'i', 'o', 'u' );
	
	private static Function<Character, Boolean> isVowel = ch -> vowels.contains(ch);
	private static Function<Character, Boolean> isLetter = ch -> Character.isAlphabetic(ch);
	private static Function<Character, Boolean> isConsonant = ch -> isLetter.apply(ch) && ! isVowel.apply(ch);

	private static record Count(int vowelTotal, int vowelDistinct, int consonantTotal, int consonantDistinct) {}	

}

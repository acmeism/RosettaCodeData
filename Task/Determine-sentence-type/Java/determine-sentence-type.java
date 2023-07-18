import java.util.List;

public final class DetermineSentenceType {

	public static void main(String[] aArgs) {
		List<String> sentences = List.of( "hi there, how are you today?",
										  "I'd like to present to you the washing machine 9001.",
										  "You have been nominated to win one of these!",
										  "Just make sure you don't break it" );

		for ( String sentence : sentences ) {
			System.out.println(sentence + " -> " + sentenceType(sentence));
		}
	}
	
	private static char sentenceType(String aSentence) {
		if ( aSentence.isEmpty() ) {
			throw new IllegalArgumentException("Cannot classify an empty sentence");
		}
		
		final char lastCharacter = aSentence.charAt(aSentence.length() - 1);
		return switch (lastCharacter) {
			case '?' -> 'Q';
			case '.' -> 'S';
			case '!' -> 'E';
			default  -> 'N';
		};		
	}	
	
}

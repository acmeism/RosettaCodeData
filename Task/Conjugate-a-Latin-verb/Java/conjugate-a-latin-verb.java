import java.util.List;

public final class ConjugateALatinVerb {

	public static void main(String[] args) {
		record Pair(String latin, String english) {}
		List<Pair> pairs = List.of( new Pair("amāre", "love"), new Pair("vidēre", "see"),
				                    new Pair("dūcere", "lead"), new Pair("audīre", "hear") );
		pairs.forEach( entry -> conjugate(entry.latin, entry.english) );		
	}
	
	private static void conjugate(String infinitive, String english) {
		if ( infinitive.length() < 4 ) {
		    throw new AssertionError("Infinitive is too short for a regular verb.");
		}
		String infinitiveEnding = infinitive.substring(infinitive.length() - 3);
		final int index = INFINITIVE_ENDINGS.indexOf(infinitiveEnding);
		if ( index < 0 ) {
		    throw new AssertionError("Infinitive ending not recognised: " + infinitiveEnding);
		}
		String stem = infinitive.substring(0, infinitive.length() - 3);
		System.out.println(
			"Present indicative tense, active voice, of '" + infinitive + "' to '" + english + "':");
		for ( int i = 0; i < ENGLISH_PRONOUNS.size(); i++ ) {
		    System.out.println(String.format("%-15s%s", "    " + stem + LATIN_ENDINGS.get(index).get(i),
		    	" " + ENGLISH_PRONOUNS.get(i) + " " + english + ENGLISH_ENDINGS.get(i)));
		}
		System.out.println();
	}
	
	private static final List<List<String>> LATIN_ENDINGS = List.of(
	   List.of( "ō", "ās", "at", "āmus", "ātis", "ant" ),
	   List.of( "eō", "ēs", "et", "ēmus", "ētis", "ent" ),
	   List.of( "ō", "is", "it", "imus", "itis", "unt" ),
	   List.of( "iō", "īs", "it", "īmus", "ītis", "iunt" ) );
	private static final List<String> INFINITIVE_ENDINGS = List.of( "āre", "ēre", "ere", "īre" );
	private static final List<String> ENGLISH_PRONOUNS =
	    List.of( "I", "you (singular)", "he, she or it", "we", "you (plural)", "they" );
	private static final List<String> ENGLISH_ENDINGS = List.of( "", "", "s", "", "", "" );

}

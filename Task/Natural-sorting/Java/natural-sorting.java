import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class NaturalSorting {

	public static void main(String[] args) {
		System.out.println("The 9 string lists, sorted 'naturally':");
	    List<String> s1 = Arrays.asList(
	        "ignore leading spaces: 2-2",
	        " ignore leading spaces: 2-1",
	        "  ignore leading spaces: 2+0",
	        "   ignore leading spaces: 2+1"
	    );
	    System.out.println();
	    s1.sort(comparator1);
	    s1.forEach(System.out::println);
	
	    List<String> s2 = Arrays.asList(
            "ignore m.a.s spaces: 2-2",
            "ignore m.a.s  spaces: 2-1",
            "ignore m.a.s   spaces: 2+0",
            "ignore m.a.s    spaces: 2+1"
        );
	    System.out.println();
	    s2.sort(comparator2);
	    s2.forEach(System.out::println);
	
	    List<String> s3 = Arrays.asList(
            "Equiv. spaces: 3-3",
            "Equiv.\rspaces: 3-2",
            "Equiv.\u000cspaces: 3-1",
            "Equiv.\u000bspaces: 3+0",
            "Equiv.\nspaces: 3+1",
            "Equiv.\tspaces: 3+2"
        );
	    System.out.println();
	    s3.sort(comparator3);
	    s3.forEach( s -> System.out.println(toDisplayString(s) ));
	
	    List<String> s4 = Arrays.asList(
            "cASE INDEPENENT: 3-2",
            "caSE INDEPENENT: 3-1",
            "casE INDEPENENT: 3+0",
            "case INDEPENENT: 3+1"
	    );
	    System.out.println();
	    s4.sort(comparator4);
	    s4.forEach(System.out::println);
	
	    List<String> s5 = Arrays.asList(
            "foo100bar99baz0.txt",
            "foo100bar10baz0.txt",
            "foo1000bar99baz10.txt",
            "foo1000bar99baz9.txt"
        );
	    System.out.println();
	    s5.sort(comparator5);
	    s5.forEach(System.out::println);
	
	    List<String> s6 = Arrays.asList(
            "The Wind in the Willows",
            "The 40th step more",
            "The 39 steps",
            "Wanda"
        );
	    System.out.println();
	    s6.sort(comparator6);
	    s6.forEach(System.out::println);
	
	    List<String> s7 = Arrays.asList(
            "Equiv. ý accents: 2-2",
            "Equiv. Ý accents: 2-1",
            "Equiv. y accents: 2+0",
            "Equiv. Y accents: 2+1"
	    );
	    System.out.println();
	    s7.sort(comparator7);
	    s7.forEach(System.out::println);
	
	    List<String> s8 = Arrays.asList(
            "Ĳ ligatured ij",
            "no ligature"
        );
	    System.out.println();
	    s8.sort(comparator8);
	    s8.forEach(System.out::println);
	
	    List<String> s9 = Arrays.asList(
            "Start with an ʒ: 2-2",
            "Start with an ſ: 2-1",
            "Start with an ß: 2+0",
            "Start with an s: 2+1"
        );
	    System.out.println();
	    s9.sort(comparator9);
	    s9.forEach(System.out::println);
	}	
	
	/** Ignoring leading space(s) */
	private static Comparator<String> comparator1 = Comparator.comparing(String::stripLeading);

	/** Ignoring multiple adjacent spaces, that is, condensing to a single space */
	private static Comparator<String> comparator2 =
		(s1, s2) -> s1.replaceAll("[ ]{2,}", " ").compareTo(s2.replaceAll("[ ]{2,}", " "));

	/** Equivalent whitespace characters (all equivalent to a single space) */
	private static Comparator<String> comparator3 =
		(s1, s2) -> s1.replaceAll("\\s+", " ").compareTo(s2.replaceAll("\\s+", " "));
	
	/** Case independent sort */			
	private static Comparator<String> comparator4 = Comparator.comparing(String::toLowerCase);
	
	/** Numeric fields as numerics (deals with numbers up to 20 digits) */
	private static Comparator<String> comparator5 = Comparator.comparing(NaturalSorting::zeroPadding);
	
	/** Title sort */
	private static Comparator<String> comparator6 = (s1, s2) ->
		s1.replaceFirst("^The\s+|^An\s+|^A\s+", "").compareTo(s2.replaceFirst("^The\s+|^An\s+|^A\s+", ""));
	
	/** Equivalent accented characters */
	private static Comparator<String> comparator7 = Comparator.comparing(NaturalSorting::replaceAccents);
	
	/** Separated ligatures */
	private static Comparator<String> comparator8 = Comparator.comparing(NaturalSorting::replaceLigatures);
	
	/** Character replacements */
	private static Comparator<String> comparator9 = Comparator.comparing(NaturalSorting::replaceCharacters);
	
	/** Display strings including whitespace as if the latter were literal characters */
	private static String toDisplayString(String text) {
	    List<String> whitespace1 = List.of( "\t", "\n", "\u000b", "\u000c", "\r" );
	    List<String> whitespace2 = List.of( "\\t", "\\n", "\\u000b", "\\u000c", "\\r" );
	    for ( int i = 0; i < whitespace1.size(); i++ ) {
	    	text = text.replace(whitespace1.get(i), whitespace2.get(i));
	    }
	    return text;
	}
	
	/** Pad each numeric character with leading zeros to a total length of 20 */
	private static String zeroPadding(String text) {		
		Pattern pattern = Pattern.compile("-?\\d+");
		Matcher matcher = pattern.matcher(text);
		StringBuilder result = new StringBuilder();
		int index = 0;
		
		while ( matcher.find() ) {	
			result.append(text.substring(index, matcher.start()));				
			result.append("0".repeat(20 - ( matcher.end() - matcher.start() )));
			result.append(text.substring(matcher.start(), matcher.end()));
			index = matcher.end();
		}		
		result.append(text.substring(index));
		
		return result.toString();
	}
	
	/** Replace accented letters with their unaccented equivalent */
	private static String replaceAccents(String text) {
		StringBuilder stringBuilder = new StringBuilder();
		for ( int i = 0; i < text.length(); i++ ) {
			final String letter = text.substring(i, i + 1);
			if ( ( text.charAt(i) & 0xff ) < 128 ) {
				stringBuilder.append(letter);
				continue;
			}
			final int length = stringBuilder.length();			

			for ( int j = 0; j < ucAccents.size(); j++ ) {
				 if ( ucAccents.get(j).contains(letter) ) {
					 stringBuilder.append(ucUnaccents.get(j));
		             break;
				 }
			}
			
			if ( length == stringBuilder.length() ) {
				for ( int j = 0; j < lcAccents.size(); j++ ) {
					if ( lcAccents.get(j).contains(letter) ) {
						stringBuilder.append(lcUnaccents.get(j));
						break;
					}
				}
			}
		}	
		return stringBuilder.toString();
	}
	
	/** Replace ligatures with separated letters */
	private static String replaceLigatures(String text) {
		for ( int i = 0; i < ucLigatures.size(); i++ ) {
			text = text.replace(ucLigatures.get(i), ucSeparates.get(i));			
		}
		for ( int i = 0; i < lcLigatures.size(); i++ ) {
			text = text.replace(lcLigatures.get(i), lcSeparates.get(i));			
		}
		return text;
	}
	
	/** Replace miscellaneous letters with their equivalent replacements */
	private static String replaceCharacters(String text) {
		for ( int i = 0; i < miscLetters.size(); i++ ) {
			text = text.replace(miscLetters.get(i), miscReplacements.get(i));			
		}
		return text;
	}
	
	/** Only covers ISO-8859-1 accented characters plus, for consistency, Ÿ */
	private static final List<String> ucAccents =
		List.of( "ÀÁÂÃÄÅ", "Ç", "ÈÉÊË", "ÌÍÎÏ", "Ñ", "ÒÓÔÕÖØ", "ÙÚÛÜ", "ÝŸ" );
	private static final List<String> lcAccents =
		List.of( "àáâãäå", "ç", "èéêë", "ìíîï", "ñ", "òóôõöø", "ùúûü", "ýÿ" );
	private static final List<String> ucUnaccents = List.of( "A", "C", "E", "I", "N", "O", "U", "Y" );
	private static final List<String> lcUnaccents = List.of( "a", "c", "e", "i", "n", "o", "u", "y" );

	/** Only the more common ligatures */
	private static final List<String> ucLigatures = List.of( "Æ", "Ĳ", "Œ" );
	private static final List<String> lcLigatures = List.of( "æ", "ĳ", "œ" );
	private static final List<String> ucSeparates = List.of( "AE", "IJ", "OE" );
	private static final List<String> lcSeparates = List.of( "ae", "ij", "oe" );

	/** Miscellaneous replacements */
	private static final List<String> miscLetters = List.of( "ß", "ſ", "ʒ" );
	private static final List<String> miscReplacements = List.of( "ss", "s", "s" );	

}

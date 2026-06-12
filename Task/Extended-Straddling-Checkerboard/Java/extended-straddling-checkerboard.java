import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class ExtendedStraddlingCheckerboard {

	public static void main(String[] args) {
		String message = "Admin ACK your MSG. CODE291 SEND further 2000 SUPP to HQ by 1 March";
		System.out.println("         " + message);
		
		String encoded = xcbEncode(message, CT37w, "κ");
		System.out.println("Encoded: " + encoded);
		System.out.println("Decoded: " + xcbDecode(encoded, CT37w, "κ"));
		
		String encodedModified = xcbEncode(message, CT37wModified, "κ");
		System.out.println("Encoded: " + encodedModified);
		System.out.println("Decoded: " + xcbDecode(encodedModified, CT37wModified, "κ"));
	}
	
    // Encode with extended straddling checkerboard.
	private static String xcbEncode(String message, List<List<String>> table, String code) {  	
	    boolean numericMode = false;
	    boolean codeMode = false;
	    int codeModeCount = 0;
	
	    final boolean equalsSlash = table.getLast().getLast().equals("/");
	    final String nChangeMode = equalsSlash ? "99" : "98";
	    final int digitRepeats = equalsSlash ? 3 : 2;

	    // Replace terms in 'messageUpperCase' that occur as a key in the dictionary 'wDict'
	    // with their corresponding dictionary value
		String messageUpperCase = message.toUpperCase();
		for ( Map.Entry<String, String> entry : wDict.entrySet() ) {
			messageUpperCase = messageUpperCase.replaceAll(entry.getKey(), entry.getValue());
		}
		
		StringBuilder encoded = new StringBuilder();
	    for ( String letter : messageUpperCase.split("") ) {
	        if ( Character.isDigit(letter.charAt(0)) ) {
	            if ( codeMode ) { // codeMode symbols are preceded by the CODE digit '6' then as-is
	                encoded.append(letter);
	                codeModeCount += 1;
	                if ( codeModeCount >= 3 ) {
	                    codeMode = false;
	                }
	            } else {
	                if ( ! numericMode ) {
	                    numericMode = true;
	                    encoded.append(nChangeMode); // FIG character
	                }
	                encoded.append(letter.repeat(digitRepeats));
	            }
	        } else {
	            codeMode = false;
	            if ( numericMode ) { // End numericMode with the FIG numeric code for '/'
	                encoded.append(nChangeMode);
	                numericMode = false;
	            }
	            if ( letter.equals(code) ) {
	                codeMode = true;
	                codeModeCount = 0;
	            }
	            for ( List<String> row : table ) {
	                if ( row.contains(letter) ) {
	                    final int k = row.indexOf(letter);
	                    encoded.append(row.getFirst() + String.valueOf(k - 1));
	                    break;
	                }
	            }
	        }
	    }
	
	    return encoded.toString();
	}
	
	// Decode with extended straddling checkerboard
	private static String xcbDecode(String encoded, List<List<String>> table, String code) {
		List<String> prefixes = table.stream()
			.map( list -> list.getFirst() ).sorted(Comparator.reverseOrder()).toList();
	    boolean numericMode = false;
	    boolean codeMode = false;
	    int pos = 0;
	    		
	    final boolean equalsSlash = table.getLast().getLast().equals("/");
	    String nChangeMode = equalsSlash ? "99" : "98";
	    final int digitRepeats = equalsSlash ? 3 : 2;
	
	    Map<String, String> numbers = IntStream.rangeClosed(0, 9)
	    	.mapToObj( i -> String.valueOf(i) ).collect(Collectors.toMap( s -> s.repeat(digitRepeats), s -> s ));

	    StringBuilder decoded = new StringBuilder();
	    while ( pos < encoded.length() ) {
	        if ( numericMode ) {
	            if ( numbers.keySet().contains(encoded.substring(pos, pos + digitRepeats)) ) {
	                decoded.append(numbers.get(encoded.substring(pos, pos + digitRepeats)));
	                pos += digitRepeats - 1;
	            } else if ( encoded.substring(pos, pos + 2).equals(nChangeMode) ) {
	                numericMode = false;
	                pos += 1;
	            } else if ( decoded.charAt(decoded.length() - 1) == '9' ) { // error, so backtrack
	                decoded.deleteCharAt(decoded.length() - 1);
	                numericMode = false;
	                pos -= digitRepeats - 1;
	            }
	        } else if ( codeMode ) {
	            if ( encoded.substring(pos, pos + 3).chars().allMatch( ch -> Character.isDigit(ch) ) ) {
	                decoded.append(encoded.substring(pos, pos + 3));
	                pos += 2;
	            }
	            codeMode = false;
	        } else if ( encoded.substring(pos, pos + 2).equals(nChangeMode) ) {
	            numericMode = ! numericMode;
	            pos += 1;
	        } else {
	            for ( String prefix : prefixes ) {
	                if ( encoded.substring(pos).startsWith(prefix) ) {
	                    final int row = IntStream.range(0, table.size())
	                    	.filter( i -> table.get(i).getFirst().equals(prefix) ).findFirst().getAsInt();
	                    String character = table.get(row)
	                    	.get(Character.getNumericValue(encoded.charAt(pos + prefix.length())) + 1);
	                    decoded.append(character);
	                    if ( character.equals(code) ) {
	                        codeMode = true;
	                    }
	                    pos += prefix.length();
	                    break;
	                }
	            }
	        }	
	        pos += 1;
	    }
	
	    String result = decoded.toString();
	    for ( Map.Entry<String, String> entry : sDict.entrySet() ) {
			result = result.replaceAll(entry.getKey(), entry.getValue());
		}
	    return result;		
	}	
	
	// CT37w from https://www.ciphermachinesandcryptology.com/en/table.htm
	private static List<List<String>> CT37w = List.of(
		List.of(  "", "A", "E", "I", "N", "O", "T", "κ",  "",  "",  "" ),
		List.of( "7", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M" ),
		List.of( "8", "P", "Q", "R", "S", "U", "V", "W", "X", "Y", "Z" ),
		List.of( "9", " ", ".", "α", "ρ", "μ", "ν", "γ", "σ", "π", "/" ) );
		
	// Modified CT37w: original CT37w, but exchange '/' (FIG) character and 'π'
	// to help differentiate the '999' encoding for a '9' from a terminator code	
	private static List<List<String>> CT37wModified = List.of(
		List.of(  "", "A", "E", "I", "N", "O", "T", "κ",  "",  "",  "" ),
		List.of( "7", "B", "C", "D", "F", "G", "H", "J", "K", "L", "M" ),
		List.of( "8", "P", "Q", "R", "S", "U", "V", "W", "X", "Y", "Z" ),
		List.of( "9", " ", ".", "α", "ρ", "μ", "ν", "γ", "σ", "/", "π" ) );
	
	private static Map<String, String> wDict = Map.ofEntries( Map.entry("CODE", "κ"),
														      Map.entry("ACK",  "α"),
														      Map.entry("REQ",  "ρ"),
														      Map.entry("MSG",  "μ"),
														      Map.entry("RV",   "ν"),
														      Map.entry("GRID", "γ"),
														      Map.entry("SEND", "σ"),
														      Map.entry("SUPP", "π") );
	
	private static Map<String, String> sDict = wDict.entrySet().stream()
		.collect(Collectors.toMap(Map.Entry::getValue, Map.Entry::getKey));

}

import java.util.List;
import java.util.function.Function;

public final class UnescapeAString {

	public static void main(String[] args) {
		List<String> tests = List.of("abc", "a☺c", "a\\\"c", "\\u0061\\u0062\\u0063", "a\\\\c",
			"a\\u263Ac", "a\\\\u263Ac", "a\\uD834\\uDD1Ec", "a\\ud834\\udd1ec",
			"a\\u263", "a\\u263Xc", "a\\uDD1Ec", "a\\uD834c", "a\\uD834\\u263Ac" );
		
		for ( String test : tests ) {
			try {
				String result = unescapeJSONString(test);
				System.out.println(test + " => " + result);
			} catch (UnescapeException exception) {
				System.out.println(test + " => " + exception.getMessage());
			}		
		}
	}
	
	private static String unescapeJSONString(String text) throws UnescapeException {
		StringBuilder result = new StringBuilder();
		int index = 0;
		while ( index < text.length() ) {
			char ch = text.charAt(index);
			
			if ( ch == '\\' ) {
				if ( index < text.length() ) {
					index += 1;
			    	ch = text.charAt(index);
				} else {
					throw new UnescapeException("Invalid escape sequence");
				}
				
			    switch ( ch ) {
				    case '\"' -> result.append("\"");
				    case '\\' -> result.append("\\");
				    case '/'  -> result.append("/");
				    case 'b'  -> result.append("\b");
				    case 'f'  -> result.append("\f");
				    case 'n'  -> result.append("\n");
				    case 'r'  -> result.append("\r");
				    case 't'  -> result.append("\t");
				    case 'u'  -> {
				    	final int startIndex = index - 1;
				        DecodeResult decodeResult = decodeHexChar(text, index);
				        if ( decodeResult.codePoint == -1 ) {
				        	return result.toString();
				        }
				        result.append(stringFromCodePoint(decodeResult.codePoint, startIndex));
				        index = decodeResult.index;				
				    }	
				    default -> throw new UnescapeException("Unknown character");
			    }
			} else {
				result.append(ch);
			}
			index += 1;
		}
		return result.toString();
	}
	
	private static DecodeResult decodeHexChar(String text, int index) throws UnescapeException {		
	    if ( index >= text.length() - 4 ) {
	        throw new UnescapeException("Incomplete escape sequence");
	    }
	
	    index += 1;
	    int codepoint = parseHexDigits(text.substring(index, index + 4), index - 2);
	    if ( isLowSurrogate.apply(codepoint) ) {
	        throw new UnescapeException("Lone low surrogate");
	    }
	
	    if ( isHighSurrogate.apply(codepoint) ) {
	        if ( ! ( index < text.length() - 9 &&
	        	text.charAt(index + 4) == '\\' && text.charAt(index + 5) == 'u' ) ) {
	        	throw new UnescapeException("Lone high surrogate");
	        }
	        final int lowSurrogate = parseHexDigits(text.substring(index + 6, index + 10), index + 4);
	        if ( ! isLowSurrogate.apply(lowSurrogate) ) {
	            throw new UnescapeException("High surrogate followed by a non-surrogate");
	        }
	        codepoint = 0x10000 + ( ( ( codepoint & 0x03ff ) << 10 ) | ( lowSurrogate & 0x03ff ) );
	        return new DecodeResult(codepoint, index + 9);
	    }
	    return new DecodeResult(codepoint, index + 3);	
	}
	
	private static int parseHexDigits(String digits, int index) throws UnescapeException {
	    int codepoint = 0;
	    for ( int digit : digits.toCharArray() ) {
	        codepoint <<= 4;
	        if ( digit >= 48 && digit <= 57 ) {
	            codepoint |= ( digit - 48 );
	        } else if ( digit >= 65 && digit <= 70 ) {
	            codepoint |= ( digit - 65 + 10 );
	        } else if ( digit >= 97 && digit <= 102 ) {
	            codepoint |= ( digit - 97 + 10 );
	        } else {
	            throw new UnescapeException("Invalid hexadecimal digit");
	        }
	    }
	    return codepoint;
	}
	
	private static Function<Integer, Boolean> isLowSurrogate  = i -> i >= 0xdc00 && i <= 0xdfff;
	private static Function<Integer, Boolean> isHighSurrogate = i -> i >= 0xd800 && i <= 0xdbff;	
	
	private static String stringFromCodePoint(int codepoint, int index) throws UnescapeException {
	    if ( codepoint > 0x10ffff || codepoint <= 0x1f ) {
	        throw new UnescapeException("Invalid character");
	    }
	    return Character.toString(codepoint);
	}
	
	private static record DecodeResult(int codePoint, int index) {}

}

final class UnescapeException extends Exception {
	
	public UnescapeException(String aMessage) {
		message = aMessage;
	}
	
	public String getMessage() {
		return message;
	}
	
	private String message;
	
}

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public final class GSTransStringConversion {

	public static void main(String[] args) {
		List<String> tests = List.of( "ALERT|G", "wert↑", "@♂aN°$ª7Î", "ÙC▼æÔt6¤☻Ì", "\"@)Ð♠qhýÌÿ",
			"+☻#o9$u♠©A", "♣àlæi6Ú.é", "ÏÔ♀È♥@ë", "Rç÷%◄MZûhZ", "ç>¾AôVâ♫↓P" );
		
		for ( String test : tests ) {
			String encoded = encode(test);
			System.out.println(test + " --> " + encoded + " --> " + decode(encoded));
		}
		System.out.println();	
		
		for ( String encoded : List.of ( "|LHello|G|J|M", "|m|j|@|e|!t|m|!|?", "abc|1de|5f" ) ) {
			System.out.println("The encoded string " + encoded + " is decoded as " + decode(encoded));
		}
	}
	
	private static String encode(String text) {
		StringBuilder result = new StringBuilder();
		byte[] bytes = text.getBytes(StandardCharsets.UTF_8);
		for ( int k = 0; k < bytes.length; k++ ) {
			int charValue = bytes[k] & 0xff;
			if ( charValue < 0 || charValue > 255 ) {
				throw new IllegalArgumentException("Character value is out of range: " + charValue);
			}
			
			StringBuilder chars = new StringBuilder();
			if ( charValue >= 128 ) {
				chars.append('|'); chars.append('!');
				charValue -= 128;
			}		

			if ( charValue <= 31 ) {
				chars.append('|'); chars.append((char) ( 64 + charValue ));
			} else if ( charValue == 34 ) {
		        chars.append('|'); chars.append('"');
		    } else if ( charValue == 124 ) {
		        chars.append('|'); chars.append('|');
		    } else if ( charValue == 127 ) {
		        chars.append('|'); chars.append('?');	
			} else {
				chars.append((char) charValue);
			}
			result.append(chars.toString());
		}	
		
		return result.toString();
	}

	private static String decode(String text) {		
		List<Byte> bytes = new ArrayList<Byte>();
	    boolean previousVerticalBar = false;
	    boolean previousExclamationMark = false;
	    int addend = 0;
	    for ( char ch : text.toCharArray() ) {
	    	if ( previousExclamationMark ) {
	            if ( ch == '|' ) {
	                addend = 128;
	                previousVerticalBar = true;
	            } else {
	                bytes.add((byte) ( 128 + ch ));
	            }	
	            previousExclamationMark = false;
	        } else if ( previousVerticalBar ) {
	            if ( ch == '?' ) {
	            	bytes.add((byte) ( 127 + addend ));
	            } else if ( ch == '!' ) {
	                previousExclamationMark = true;
	            } else if ( ch == '|' || ch == '"' || ch == '<' ) {
	                bytes.add((byte) ( ch + addend ));
	        	} else if ( ch == '[' || ch == '{' ) {
	                bytes.add((byte) ( 27 + addend ));
	    		} else if ( ch == '\\' ) {
	                bytes.add((byte) ( 28 + addend ));
	    		} else if ( ch == ']' || ch == '}' ) {
	                bytes.add((byte) ( 29 + addend ));
	    		} else if ( ch == '^' || ch == '~' ) {
	                bytes.add((byte) ( 30 + addend ));
	    		} else if ( ch == '_' || ch == '`' ) {
	                bytes.add((byte) ( 31 + addend ));
	    		} else {
	                final int value = Integer.valueOf(Character.toUpperCase(ch)) - 64 + addend;
	                if ( 0 < value && value < 32 ) {
	            		byte[] newBytes = ( "CHR$(" + String.valueOf(value) + ")" ).getBytes();
	            		for ( byte bb : newBytes ) {
	            			bytes.add(bb);
	            		}
	                } else if ( value > 0 ) {
	                	bytes.add((byte) value);
	                } else {
	                	bytes.add((byte) ch);
	                }
	    		}	
	            previousVerticalBar = false;
	            addend = 0;
	        } else if ( ch == '|' ) {
	            previousVerticalBar = true;
	        } else {
	            bytes.add((byte) ch);
	        }
	    }
	
	    String decoded = "";	
	    List<Byte> highValueBytes = new ArrayList<Byte>();
		for ( byte bb = 0; bb < bytes.size(); bb++ ) {
			if ( bytes.get(bb) > 0 ) {
				decoded += decodeHighValueBytes(highValueBytes);				
				decoded += new String( new byte[] { bytes.get(bb) }, StandardCharsets.UTF_8 );
			} else {
				highValueBytes.add(bytes.get(bb));		
			}		
		}
		decoded += decodeHighValueBytes(highValueBytes);
		return decoded;		
	}
	
	private static String decodeHighValueBytes(List<Byte> highValueBytes) {
		String result = "";
		if ( ! highValueBytes.isEmpty() ) {
			if ( highValueBytes.size() == 1 ) {
				result += Character.toString(highValueBytes.get(0) & 0xff);
			} else {
				byte[] newBytes = new byte[highValueBytes.size()];
				for ( int j = 0; j < highValueBytes.size(); j++ ) {
					newBytes[j] = highValueBytes.get(j);
				}
				result += new String(newBytes, StandardCharsets.UTF_8);
			}
			highValueBytes.clear();
		}
		return result;
	}

}

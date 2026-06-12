import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.regex.MatchResult;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public final class HexDump {

	public static void main(String[] args) throws IOException {
		byte[] bytes = Files.readAllBytes(Path.of("ExampleUTF16LE.dat"));		
			
		System.out.println("Hex dump of the entire file:");
		System.out.println( new Converter(bytes, 0, bytes.length, DumpType.HEX).toConvertedString() );
		System.out.println();
		
		System.out.println("xxd dump of the entire file:");
		System.out.println( new Converter(bytes, 0, bytes.length, DumpType.XXD).toConvertedString() );
		System.out.println();
		
		System.out.println("Hex dump of the file from byte 20 to byte 94:");
		System.out.println( new Converter(bytes, 20, 75, DumpType.HEX).toConvertedString() );
		System.out.println();
		
		System.out.println("xxd dump of the file from byte 38 to byte 58:");
		System.out.println( new Converter(bytes, 38, 21, DumpType.XXD).toConvertedString() );
	}

	private static final class Converter {
		
		public Converter(byte[] aBytes, int aStartIndex, int aLength, DumpType aDumpType) {
			startIndex = Math.min(aBytes.length, Math.max(0, aStartIndex));
			length = ( aLength < 1 || aLength > aBytes.length - startIndex ) ? aBytes.length - startIndex : aLength;
			dumpType = aDumpType;
			
			bytes = IntStream.range(startIndex, startIndex + length).mapToObj( i -> aBytes[i] ).toList();
		}
		
		public String toConvertedString() {
			return IntStream.iterate(0, i -> i * dumpType.factor < bytes.size(), i -> i + 1)
				.mapToObj( i -> byteList(i * dumpType.factor, dumpType.factor) )
		        .map( list -> toConvertedRow(list) )
		        .collect(Collectors.joining())
		        + toHex(counterFinish);
		}
		
		private List<Byte> byteList(int currentIndex, int currentLength) {
	    	counterStart = currentIndex;
	    	counterFinish = Math.min(currentIndex + currentLength, bytes.size());
	    	
	    	return bytes.subList(currentIndex, counterFinish);
	    }
		
		private String toConvertedRow(List<Byte> row) {    	
	        String line = row.stream().map( b -> toDigit(b) ).collect(Collectors.joining());
	        line = padding(insertSpace(line));
	
	        return toHex(counterStart) + line + "|" +
	        	   row.stream().map( b -> printableCharacter(b) ).collect(Collectors.joining()) + "|" + "\n";
	    }
		
		private String insertSpace(String line) {
			return Pattern.compile(".{1," + dumpType.blockLength + "}")
				.matcher(line).results().map(MatchResult::group).collect(Collectors.joining(" "));		
	    }
		
		private String toDigit(int number) {
			return switch ( dumpType ) {
				case HEX -> String.format("%02x ", number & 0xff);
				case XXD -> Integer.toBinaryString( ( 1 << 8 | ( number & 0xff ) ) ).substring(1);
			};
	    }
		
		private String printableCharacter(int number) {
		    return ( number >= 32 && number < 127 ) ? String.valueOf((char) number) : ".";
		}		
		
		private String padding(String line) {
	    	return String.format("%1$-" + dumpType.lineLength + "s", line);
	    } 	
		
		private String toHex(int number) {
	    	return String.format("%08x  ", number);
	    }
		
		private int counterStart, counterFinish;		
		
		private final int startIndex, length;
		private final List<Byte> bytes;
		private final DumpType dumpType;
		
	}
	
	private static enum DumpType {
		
		HEX(16, 24, 50), XXD(6, 8, 55);
		
		private DumpType(int aFactor, int aBlockLength, int aLineLength) {
			factor = aFactor;
			blockLength = aBlockLength;
			lineLength = aLineLength;
		}
		
		private final int factor, blockLength, lineLength;
		
	}

}

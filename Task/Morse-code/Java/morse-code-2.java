import java.util.Map;
import java.util.stream.IntStream;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;

public final class MorseCode {

	public static void main(String[] args) {
		Map<String, String> morseCode = Map.ofEntries(
			// International Morse Code, ITU standard
			Map.entry("A", ".-"), Map.entry("B", "-..."), Map.entry("C", "-.-."), Map.entry("D", "-.."),
			Map.entry("E", "."), Map.entry("F", "..-."), Map.entry("G", "--."), Map.entry("H", "...."),
			Map.entry("I", ".."), Map.entry("J", ".---"), Map.entry("K", "-.-"), Map.entry("L", ".-.."),
			Map.entry("M", "--"), Map.entry("N", "-."), Map.entry("O", "---"), Map.entry("P", ".--."),
			Map.entry("Q", "--.-"), Map.entry("R", ".-."), Map.entry("S", "..."), Map.entry("T", "-"),
			Map.entry("U", "..-"), Map.entry("V", "...-"), Map.entry("W", ".--"), Map.entry("X", "-..-"),
			Map.entry("Y", "-.--"), Map.entry("Z", "--.."),
			
			Map.entry("1", ".----"), Map.entry("2", "..---"), Map.entry("3", "...--"), Map.entry("4", "....-"),
			Map.entry("5", "....."), Map.entry("6", "-...."), Map.entry("7", "--..."), Map.entry("8", "---.."),
			Map.entry("9", "----."), Map.entry("0", "-----"),
			
			// Generally accepted additions
			Map.entry("'", ".----."), Map.entry(":", "---..."), Map.entry(",", "--..--"), Map.entry("-", "-....-"),
			Map.entry("(", "-.--.-"), Map.entry(".", ".-.-.-"), Map.entry("?", "..--.."), Map.entry(";", "-.-.-."),
			Map.entry("/", "-..-."), Map.entry(")", "---.."), Map.entry("=", "-...-"), Map.entry("@", ".--.-."),
			Map.entry("\"", ".-..-."), Map.entry("+", ".-.-.")
		);		
		
		prepareSourceDataLine();
		
		final int frequency = 1280;   // Frequency of the sound tone in Hertz
		final int time = 250;         // Time unit in milliseconds
		
		// Correct pacing of the sound transmission is essential for practical use
		final int dot = 1;            // Time units taken for one dot
		final int dash = 3;           // Time units taken for one dash
		final int interval = 1;       // Time units interval between dots and dashes
		final int letterInterval = 1; // Time units interval between letters of a word
		final int wordInterval = 7;   // Time units interval between words			
		
		String message = "Hello World";
		
		for ( String letter : message.toUpperCase().split("") ) {
			switch ( letter ) {
				case " " -> tone(0, time * wordInterval, 0);
				default -> {
					String code = morseCode.get(letter);
					for ( String dotDash : code.split("") ) {
						switch ( dotDash ) {
							case "." -> { tone(frequency, time * dot, 1); tone(0, time * interval, 0); }
							case "-" -> { tone(frequency, time * dash, 1); tone(0, time * interval, 0); }
						}				
					}
				}
			}
			tone(0, time * letterInterval, 0);
		}		
	}	
	
	private static void tone(double frequency, int duration, int volume) {
	    sourceDataLine.start();
	
	    IntStream.range(0, 8 * duration).forEach( i -> {
	        final double angle = i / ( SAMPLE_RATE / frequency ) * 2 * Math.PI;
	        byte[] buffer = new byte[] { (byte) ( Math.sin(angle) * 127 * volume ) };
	        sourceDataLine.write(buffer, BYTE_OFFSET, buffer.length);
	    } );
	
	    sourceDataLine.drain();
	    sourceDataLine.stop();
	}
	
	private static void prepareSourceDataLine() {
		final int sampleSizeInBits = 8;
		final int numberChannels = 1;
		final boolean signedData = true;
		final boolean isBigEndian = false;
		
	    AudioFormat audioFormat = new AudioFormat(
	    	SAMPLE_RATE, sampleSizeInBits, numberChannels, signedData, isBigEndian);
	
		try {
			sourceDataLine = AudioSystem.getSourceDataLine(audioFormat);
			sourceDataLine.open(audioFormat);
		} catch (LineUnavailableException lue) {
			lue.printStackTrace();
		}	
	}
	
	private static SourceDataLine sourceDataLine;
	
	private static float SAMPLE_RATE = 8_000.0F;
	private static final int BYTE_OFFSET = 0;
	
}

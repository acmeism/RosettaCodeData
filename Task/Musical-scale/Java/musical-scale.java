import java.util.List;
import java.util.stream.IntStream;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;

public final class MusicalScale {

	public static void main(String[] aArgs) {
		List<Double> frequencies = List.of( 261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25 );	
		
		prepareSourceDataLine();
		
		final int duration = 500; // in milliseconds
		final int volume = 1;
		
		IntStream.range(0, 3).forEach( _ -> {
			for ( double frequency : frequencies ) {
				musicalTone(frequency, duration, volume);
			}
		} );
		
		sourceDataLine.close();
	}
	
	private static void musicalTone(double frequency, int duration, int volume) {
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

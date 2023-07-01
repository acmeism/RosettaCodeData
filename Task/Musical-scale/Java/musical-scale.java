import java.util.List;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;

public final class MusicalScale {

	public static void main(String[] aArgs) {
		List<Double> frequencies = List.of( 261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25 );
		final int duration = 500;
		final int volume = 1;
		
		for ( int i = 0; i < 3; i++ ) {
			for ( double frequency : frequencies ) {
				musicalTone(frequency, duration, volume);
			}
		}
	}
	
	private static void musicalTone(double aFrequency, int aDuration, int aVolume) {
	    byte[] buffer = new byte[1];
	    AudioFormat audioFormat = getAudioFormat();	
	
		try ( SourceDataLine sourceDataLine = AudioSystem.getSourceDataLine(audioFormat) ) {		
		    sourceDataLine.open(audioFormat);
		    sourceDataLine.start();
		
		    for ( int i = 0; i < aDuration * 8; i++ ) {
		        double angle = i / ( SAMPLE_RATE / aFrequency ) * 2 * Math.PI;
		        buffer[0] = (byte) ( Math.sin(angle) * 127 * aVolume );
		        sourceDataLine.write(buffer, BYTE_OFFSET, buffer.length);
		    }
		
		    sourceDataLine.drain();
		    sourceDataLine.stop();
		    sourceDataLine.close();
		} catch (LineUnavailableException exception) {
			exception.printStackTrace();
		}
	}
	
	private static AudioFormat getAudioFormat() {
		final int sampleSizeInBits = 8;
		final int numberChannels = 1;
		final boolean signedData = true;
		final boolean isBigEndian = false;
		
		return new AudioFormat(SAMPLE_RATE, sampleSizeInBits, numberChannels, signedData, isBigEndian);
	}
	
	private static float SAMPLE_RATE = 8_000.0F;
	private static final int BYTE_OFFSET = 0;

}

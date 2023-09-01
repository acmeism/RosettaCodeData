import java.io.File;
import java.io.IOException;
import java.util.Scanner;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

public final class PlayRecordedSounds {

	public static void main(String[] aArgs) {
		PlayRecordedSounds soundPlayer = new PlayRecordedSounds();			
		soundPlayer.play();
		
		scanner = new Scanner(System.in); 			
		int choice = 0;
		while ( choice != 6 ) {
			System.out.println("1. Pause");
			System.out.println("2. Resume");
			System.out.println("3. Restart");
			System.out.println("4. Jump to specific time");
			System.out.println("5. Stop");
			System.out.println("6. Quit the program");
			
			choice = scanner.nextInt();
			soundPlayer.select(choice);
		}
		scanner.close();
	}
	
	private enum Status { PLAYING, PAUSED, STOPPED }

	private PlayRecordedSounds() {
		resetAudioStream();
	} 	
	
	private void select(int aChoice) {
		switch ( aChoice ) {
			case 1 -> pause();
			case 2 -> resume();
			case 3 -> restart();
			case 4 -> jump();
			case 5 -> stop();
			case 6 -> quit();
			default -> { /* Take no action */ }	
		} 	
	}
	
	private void play() {		
		status = Status.PLAYING;
		clip.start();
	}
	
	private void pause() {
		if ( status == Status.PAUSED ) {
			System.out.println("The audio is already paused");
			return;
		}
		
		currentClipPosition = clip.getMicrosecondPosition();
		clip.stop();
		status = Status.PAUSED;
	}
	
	private void resume() {
		if ( status == Status.PLAYING ) {
			System.out.println("The audio is already being played");
			return;
		}
		
		clip.close();
		resetAudioStream();
		clip.setMicrosecondPosition(currentClipPosition);
		status = Status.PLAYING;
		play();
	}
	
	private void restart() {		
		clip.stop();
		clip.close();
		resetAudioStream();
		currentClipPosition = 0;
		clip.setMicrosecondPosition(currentClipPosition);
		status = Status.PLAYING;
		play();
	}
	
	private void jump() {	
		System.out.println("Select a time between 0 and " + clip.getMicrosecondLength());
		final long request = scanner.nextLong();	
		
		if ( request > 0 && request < clip.getMicrosecondLength() ) {
			clip.stop();
			clip.close();
			resetAudioStream();
			currentClipPosition = request;
			clip.setMicrosecondPosition(currentClipPosition);
			status = Status.PLAYING;
			play();
		}
	}
	
	private void stop() {
		currentClipPosition = 0;
		clip.stop();
		clip.close();
		status = Status.STOPPED;
	}
	
	private void quit() {
		try {
			scanner.close();
			clip.close();
			audioStream.close();
			Runtime.getRuntime().exit(0);
		} catch (IOException ioe) {
			ioe.printStackTrace(System.err);
		}
	}
	
	private void resetAudioStream() {
		try {
			audioStream = AudioSystem.getAudioInputStream( new File(FILE_PATH) );
			clip = AudioSystem.getClip();
			clip.open(audioStream);
			clip.loop(Clip.LOOP_CONTINUOUSLY);
		} catch (UnsupportedAudioFileException | IOException | LineUnavailableException exception) {
			exception.printStackTrace(System.err);
		}		
	} 	

	private static Scanner scanner;
	private static Clip clip;
	private static long currentClipPosition;
	private static Status status;
	private static AudioInputStream audioStream;
	
	private static final String FILE_PATH = "./test_piece.wav";
	
}

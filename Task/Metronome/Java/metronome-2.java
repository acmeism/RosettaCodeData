import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.io.IOException;
import java.net.URL;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JPanel;

public final class MetronomeTask {

	public static void main(String[] aArgs) {
		EventQueue.invokeLater( () -> { new Metronome(60, 4, 1).start(); } );
	}	

}

final class Metronome extends JPanel {
	
	public Metronome(int aBeatsPerMinute, int aMeasure, int aDurationInMinutes) {
		beatsPerMinute = aBeatsPerMinute; measure = aMeasure; durationInMinutes = aDurationInMinutes;
		SoundEffect.initialise();
		createAndShowGUI();
	}
	
	public void start() {
		executorService = Executors.newSingleThreadScheduledExecutor();
		executorService.scheduleAtFixedRate(provideService, 1, 1, TimeUnit.SECONDS);	
	}	
	
	private void createAndShowGUI() {
		JFrame.setDefaultLookAndFeelDecorated(true);
        frame = new JFrame("Metronome");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setIconImage( new ImageIcon("./metronomeJava.png").getImage() );
        frame.add(createPanel());
        frame.pack();
		frame.setLocationRelativeTo(null);
		frame.setResizable(false);
        frame.setVisible(true);
	}
	
	private JPanel createPanel() {
		setPreferredSize( new Dimension(800, 600) );
        setBackground(Color.CYAN);
        return this;
	}	
	
	private JFrame frame;
	private ScheduledExecutorService executorService;
	private int beatsPerMinute, measure, durationInMinutes, counter;	
	
	private Runnable provideService = () -> {	
		if ( counter < durationInMinutes * beatsPerMinute ) {
			counter++;
			if ( counter % measure != 0 ) {
				SoundEffect.Tick.play();
				if ( getBackground() != Color.PINK ) {
					setBackground(Color.PINK);
				} else {
					setBackground(Color.CYAN);
				}
			} else {
				SoundEffect.Tock.play();
				setBackground(Color.ORANGE);
			}
		} else {
			executorService.shutdown();
			frame.dispose();
			Runtime.getRuntime().exit(0);
		}
	};
	
}

enum SoundEffect {
	
    Tick("./metronomeTickJava.wav"), Tock("./metronomeTockJava.wav");
	
    public static void initialise() {
    	values();
    }

    public void play() {
    	if ( clip.isRunning() ) {
    		clip.stop();
    	}
			clip.setFramePosition(0);
			clip.start();
    }

    private SoundEffect(String soundFileName) {
    	URL url = getClass().getClassLoader().getResource(soundFileName);
        try ( AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(url) ) {
            clip = AudioSystem.getClip();
            clip.open(audioInputStream);
        } catch (IOException | LineUnavailableException | UnsupportedAudioFileException ex) {
            ex.printStackTrace();
        }
    }

    private Clip clip;

}

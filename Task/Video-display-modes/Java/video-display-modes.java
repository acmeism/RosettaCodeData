import java.awt.Color;
import java.awt.DisplayMode;
import java.awt.GraphicsConfiguration;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.util.concurrent.TimeUnit;

import javax.swing.JFrame;
import javax.swing.JLabel;

public final  class VideoDisplay {
	
	public static void main(String[] aArgs) throws InterruptedException  {	
		GraphicsEnvironment environment = GraphicsEnvironment.getLocalGraphicsEnvironment();
	   	GraphicsDevice[] screens = environment.getScreenDevices();
	   	System.out.println("Number of video screens: " + screens.length + System.lineSeparator());
	   	
	   	for ( GraphicsDevice screen : screens ) {
	   		System.out.println("Full screen display is supported: "
	   			+ screen.isFullScreenSupported() + System.lineSeparator());
	   		
	   		GraphicsConfiguration[] configurations = screen.getConfigurations();
	   		
	   		System.out.println("This screen has number of configurations: " + configurations.length);
	   		for ( GraphicsConfiguration config : configurations ) {
	   			System.out.println("Configuration supports translucency: " + config.isTranslucencyCapable());	
	   		}
	   		
	   		DisplayMode[] modes = screen.getDisplayModes();
	   		System.out.println(System.lineSeparator() + "This screen has " + modes.length + " modes of operation");
	   		
	   		for ( DisplayMode mode : modes ) {
		         System.out.println(mode.getWidth() + " X " + mode.getHeight()
		         	+ " with refresh rate " + mode.getRefreshRate() + " Hz");			
		    }		
	    }
	   	
	   	// Uncomment the line below to see an example of programmatically changing the video display.
	   	// new VideoDisplay();		
	}
	
	private VideoDisplay() throws InterruptedException {
		JFrame.setDefaultLookAndFeelDecorated(true);
    	JFrame frame = new JFrame("Video Display Demonstration");    	
    	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    	frame.setBackground(Color.LIGHT_GRAY);
    	frame.add( new JLabel(MESSAGE) );
    	frame.setSize(800, 600);
    	
    	GraphicsDevice screen = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();
    	DisplayMode originalDisplayMode = screen.getDisplayMode();
    	screen.setFullScreenWindow(frame);
    	screen.setDisplayMode( new DisplayMode(800, 600, 32, 60) );
    	frame.setVisible(true);

    	TimeUnit.SECONDS.sleep(3);

    	screen.setDisplayMode(originalDisplayMode);
    	
    	TimeUnit.SECONDS.sleep(3);
    	
    	Runtime.getRuntime().exit(0);
    }

    private static final String MESSAGE = "Please wait for a few seconds."
    	+ " Your video display will then be returned to its original setting.";
	
}

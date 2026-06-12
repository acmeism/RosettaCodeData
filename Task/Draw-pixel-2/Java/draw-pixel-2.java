import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.util.concurrent.ThreadLocalRandom;

import javax.swing.JFrame;
import javax.swing.JPanel;

public final class DrawAPixel2 extends JPanel {

	public static void main(String[] args) {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Draw a pixel 2");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.add( new DrawAPixel2() );
    		frame.setLocationByPlatform(true);
    		frame.setResizable(false);
    		frame.pack();
            frame.setVisible(true);
        } );
	}
	
	@Override
    public void paintComponent(Graphics graphics) {
    	super.paintComponent(graphics);    	
    	graphics.drawImage(image, 0, 0, this);
    }
	
	private DrawAPixel2() {
		setBackground(Color.BLACK);
		setPreferredSize( new Dimension(640, 480) );
		
		ThreadLocalRandom random = ThreadLocalRandom.current();
		final int xCoord = random.nextInt(1, 640);
		final int yCoord = random.nextInt(1, 480);
		
		final int colorYellow = 255 << 16 | 255 << 8 | 0;		
		image = new BufferedImage(640, 480, BufferedImage.TYPE_INT_RGB);
		image.setRGB(xCoord, yCoord, colorYellow);
	}
	
	private static BufferedImage image;

}

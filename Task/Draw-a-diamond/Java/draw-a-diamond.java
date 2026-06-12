import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class DrawADiamond extends JComponent {

	public static void main() {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Diamond");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);
            frame.add( new DrawADiamond() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
        graphics.drawImage(createDiamond(), 0, 0, this);
	}
	
	private BufferedImage createDiamond() {
	    BufferedImage bufferedImage = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
	    Graphics2D graphics2D = bufferedImage.createGraphics();
	
	    graphics2D.setColor( new Color(120, 255, 255) );
	    graphics2D.setStroke( new BasicStroke(3) );

        final int centreX = 300;
        final int upperY = 150;
        final int innerY = 230;
        final int lowerY = 450;

        // Symmetrical drawing around the centre x axis
        graphics2D.drawLine(centreX - 80,  upperY, centreX + 80,  upperY); // Top
        graphics2D.drawLine(centreX + 80,  upperY, centreX + 160, innerY); // Upper right
        graphics2D.drawLine(centreX + 160, innerY, centreX,       lowerY); // Lower right
        graphics2D.drawLine(centreX,       lowerY, centreX - 160, innerY); // Lower left
        graphics2D.drawLine(centreX - 160, innerY, centreX - 80,  upperY); // Upper left

        // Inner edges (facets) aligned to the centre line
        graphics2D.drawLine(centreX - 160, innerY, centreX + 160, innerY); // Girdle line
        graphics2D.drawLine(centreX - 80,  upperY, centreX,       lowerY); // Inner left diagonal
        graphics2D.drawLine(centreX + 80,  upperY, centreX,       lowerY); // Inner right diagonal
	
        graphics2D.dispose();
	    return bufferedImage;
	}
	
	private DrawADiamond() {
		setPreferredSize( new Dimension(WIDTH, HEIGHT) );
		setBackground(Color.DARK_GRAY);
	}
	
	private static final int WIDTH = 600;
	private static final int HEIGHT = 600;

}

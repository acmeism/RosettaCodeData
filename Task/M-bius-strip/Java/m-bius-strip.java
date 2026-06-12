import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class MöbiusStrip extends JComponent {

	public static void main() {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Möbius Strip");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setPreferredSize( new Dimension(WIDTH, HEIGHT) );
            frame.setResizable(false);
            frame.add( new MöbiusStrip() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
        graphics.drawImage(createMöbiusStrip(), 0, 0, this);
	}
	
	private static BufferedImage createMöbiusStrip() {
		BufferedImage bufferedImage = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
		Graphics2D graphics2D = bufferedImage.createGraphics();		
        graphics2D.setColor(Color.RED);
        graphics2D.setStroke( new BasicStroke(2) );
		
		final int centreX = WIDTH / 2;
	    final int centreY = HEIGHT / 2;
	    final double radius = 150.0;
	    final double halfWidth = 60.0;
	    final double k = 0.3;
	
	    for ( double angle = 0.0; angle < TWO_PI; angle += 0.0349 ) {
	    	
	    	 // Inner edge point
	         final double v1 = -halfWidth;
	         final double x1 = ( radius + v1 * Math.cos(angle / 2) ) * Math.cos(angle);
	         final double y1 = ( radius + v1 * Math.cos(angle / 2) ) * Math.sin(angle);
	         final double z1 = v1 * Math.sin(angle / 2);
	         final double innerX = centreX + x1 + ( z1 * k );
	         final double innerY = centreY + y1 - ( z1 * k );
	
	         // Outer edge point
	         final double v2 = halfWidth;
	         final double x2 = ( radius + v2 * Math.cos(angle / 2) ) * Math.cos(angle);
	         final double y2 = ( radius + v2 * Math.cos(angle / 2) ) * Math.sin(angle);
	         final double z2 = v2 * Math.sin(angle / 2);
	         final double outerX = centreX + x2 + ( z2 * k );
	         final double outerY = centreY + y2 - ( z2 * k );
	
	         graphics2D.drawLine((int) innerX, (int) innerY, (int) outerX, (int) outerY);
	    }
	
	    graphics2D.dispose();
		return bufferedImage;
	}
	
	private MöbiusStrip() {
		setPreferredSize( new Dimension(WIDTH, HEIGHT) );
		setBackground(Color.DARK_GRAY);
	}
	
	private static final int WIDTH = 600;
	private static final int HEIGHT = 600;
	private static final double TWO_PI = 2.0 * Math.PI;

}

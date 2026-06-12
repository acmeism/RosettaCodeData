import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class DrawATorus extends JComponent {

	public static void main() {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Torus");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);
            frame.add( new DrawATorus() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
        graphics.drawImage(createTorus(), 0, 0, this);
	}
	
	private Image createTorus() {
	    BufferedImage bufferedImage = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
	
	    final double externalRadius = 150.0;
		final double internalRadius = 60.0;
		
		// Rotation angles in radians
		final double A = 0.5; // Tilt around the X axis
		final double B = 0.5; // Tilt around the Z axis
		
		final double sinA = Math.sin(A);
		final double cosA = Math.cos(A);
		final double sinB = Math.sin(B);
		final double cosB = Math.cos(B);
		
		for ( double j = 0.0; j < TWO_PI; j += 0.01 ) {
			for ( double i = 0.0; i < TWO_PI; i += 0.04 ) {

	            final double sinI = Math.sin(i);
	            final double cosI = Math.cos(i);
	            final double sinJ = Math.sin(j);
	            final double cosJ = Math.cos(j);
	
	            // 3D coordinate calculation
	            final double h = externalRadius + internalRadius * cosJ;
	
                final double x = h * ( cosB * cosI + sinA * sinB * sinI ) - internalRadius * cosA * sinB * sinJ;
                final double y = h * ( sinB * cosI - sinA * cosB * sinI ) + internalRadius * cosA * cosB * sinJ;
                final double z = h * cosA * sinI + internalRadius * sinA * sinJ;

                // Luminance calculation
                final double factor = cosJ * cosI * sinB - sinA * cosJ * sinI * cosB - cosA * sinJ * cosB;
                final double luminance = 8.0 * ( factor - cosI * sinJ * sinA );

                if ( luminance > 0.0 ) {
                    // Set color based on brightness (0 - 255)
                    final int brightness = Math.min( (int) ( luminance * 30 ), 255);

                    Color color = new Color(brightness / 2, brightness, 255);

                    // Perspective projection into 2D
                    final double ooz = 1.0 / ( z + 500.0 );
                    final int xCoord = (int) ( 400.0 + x * ooz * 600.0 );
                    final int yCoord = (int) ( 300.0 - y * ooz * 600.0 );

                    bufferedImage.setRGB(xCoord, yCoord, color.getRGB());
                }
            }
	    }

	    return bufferedImage;
	}
	
	private DrawATorus() {
		setPreferredSize( new Dimension(WIDTH, HEIGHT) );
		setBackground(Color.DARK_GRAY);
	}
		
	private static final int WIDTH = 800;
	private static final int HEIGHT = 540;
	private static final double TWO_PI = 2.0 * Math.PI;

}

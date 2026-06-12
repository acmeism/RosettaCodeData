import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.Graphics;

import javax.swing.JFrame;
import javax.swing.JPanel;

public final class FourSidesOfASquare extends JPanel {

	public static void main(String[] args) {
		 EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Four Sides of a Square");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.add( new FourSidesOfASquare(BOX_COUNT) );
            frame.pack();
    		frame.setLocationByPlatform(true);
    		frame.setResizable(false);
            frame.setVisible(true);
        } );
	}
	
	@Override
    public void paintComponent(Graphics graphics) {
    	super.paintComponent(graphics);
    	
    	Color beige = new Color(245, 245, 220);
        Color brown = new Color(204, 102, 51);

        graphics.setFont(getFont().deriveFont(Font.BOLD, 20.0F));
    	
    	for ( int x = 0; x < squareSize; x++ ) {
            for ( int y = 0; y < squareSize; y++ ) {
                final int cx = x * 60 + 10;
                final int cy = y * 60 + 10;
                if ( x == 0 || x == BOX_COUNT - 1 || y == 0 || y == BOX_COUNT - 1 ) {                	
                	graphics.setColor(brown);
                    graphics.fillRect(cx, cy, 50, 50);
                    graphics.setColor(beige);
                    graphics.drawString("1", cx + 20, cy + 30);
                } else {
                 	graphics.setColor(beige);
                    graphics.fillRect(cx, cy, 50, 50);
                    graphics.setColor(brown);
                    graphics.drawString("0", cx + 20, cy + 30);
                }
            }
        }
    }
	
	private FourSidesOfASquare(int squareCount) {
		squareSize = 60 * squareCount + 10;
		setPreferredSize( new Dimension(squareSize, squareSize) );
        setBackground(Color.LIGHT_GRAY);
	}
	
	private static int squareSize;
	
	private static final int BOX_COUNT = 6;
	
}

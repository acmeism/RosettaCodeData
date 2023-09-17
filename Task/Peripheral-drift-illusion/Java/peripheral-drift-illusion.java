import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JPanel;

public final class PeripheralDriftIllusion {

	public static void main(String[] aArgs) {
		 EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Peripheral Drift Illusion");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.add( new PeripheralDrift() );
            frame.pack();
    		frame.setLocationRelativeTo(null);
    		frame.setResizable(false);
            frame.setVisible(true);
        } );
	}	
}

final class PeripheralDrift extends JPanel {
	
	public PeripheralDrift() {
		setPreferredSize( new Dimension(600, 600) );
		setBackground(LIGHT_OLIVE);
	}
	
	@Override
	public void paintComponent(Graphics aGraphics) {
	   	super.paintComponent(aGraphics);
	   	Graphics2D graphics2D = (Graphics2D) aGraphics;
	   	graphics2D.setStroke( new BasicStroke(3.0F) );
	   	drawPeripheralDrift(graphics2D);
	}	
	
	private void drawPeripheralDrift(Graphics2D aGraphics2D) {
		final int panelWidth = getWidth();
		final int outerSquare = panelWidth * 80 / 100;
		final int border = ( panelWidth - outerSquare ) / 2;
		final int cellSize = outerSquare / 12;	
		final int boxSize = cellSize * 75 / 100;
		final int margin = ( cellSize - boxSize ) / 2;
	
		for ( int row = 0; row < 12; row++ ) {
			int x = border + margin + row * cellSize;
			for ( int col = 0; col < 12; col++ ) {
				int y = border + margin + col * cellSize;
				drawBox(x, y, boxSize, EDGES.get(col).get(row), aGraphics2D);
			}
		}
	}
	
	private void drawBox(int aX, int aY, int aSize, Edg aEdge, Graphics2D aGraphics2D) {		
		aGraphics2D.setColor(PALE_BLUE);
		aGraphics2D.fillRect(aX, aY, aSize, aSize);
		
		aGraphics2D.setColor(COLORS.get(aEdge.index).get(0));
		aGraphics2D.drawLine(aX, aY, aX + aSize, aY);
		aGraphics2D.setColor(COLORS.get(aEdge.index).get(1));
		aGraphics2D.drawLine(aX + aSize, aY, aX + aSize, aY + aSize);
		aGraphics2D.setColor(COLORS.get(aEdge.index).get(2));
		aGraphics2D.drawLine(aX + aSize, aY + aSize, aX, aY + aSize);
		aGraphics2D.setColor(COLORS.get(aEdge.index).get(3));
		aGraphics2D.drawLine(aX, aY + aSize, aX, aY);		
	}	

	private enum Edg {
		
		TL(0), TR(1), BR(2), BL(3);
		
		private Edg(int aIndex) {
			index = aIndex;
		}
		
		private final int index;
	
	}

	private static final List<List<Edg>> EDGES = List.of(
		List.of( Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR ),
		List.of( Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL ),
		List.of( Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL ),
		List.of( Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL ),
		List.of( Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL ),
		List.of( Edg.BR, Edg.BR, Edg.TR, Edg.BR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR ),
		List.of( Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR ),
		List.of( Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR ),
		List.of( Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR ),
		List.of( Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL ),
		List.of( Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL ),
		List.of( Edg.TR, Edg.TR, Edg.TL, Edg.TL, Edg.BL, Edg.BL, Edg.BR, Edg.BR, Edg.TR, Edg.TR, Edg.TL, Edg.TL ) );
	
	private static final List<List<Color>> COLORS = List.of(
		List.of( Color.WHITE, Color.BLACK, Color.BLACK, Color.WHITE ),
		List.of( Color.WHITE, Color.WHITE, Color.BLACK, Color.BLACK ),
		List.of( Color.BLACK, Color.WHITE, Color.WHITE, Color.BLACK ),
		List.of( Color.BLACK, Color.BLACK, Color.WHITE, Color.WHITE ) );
	
	private static final Color PALE_BLUE = new Color(51, 77, 255);
	private static final Color LIGHT_OLIVE = new Color(204, 204, 0);
			
}

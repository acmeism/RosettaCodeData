import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.random.RandomGenerator;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class VibratingRectangles extends JComponent implements Runnable {

	public static void main() {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Vibrating Rectangles");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);
            frame.add( new VibratingRectangles() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
	}
	
	@Override
	public void run() {
		changeCount += 1;
		if ( changeCount == RECTANGLE_COUNT ) {
			changeCount = 0;
			previousColor = currentColor;
			do {
				currentColor = COLORS.get(random.nextInt(COLORS.size()));
			} while ( currentColor == previousColor );
		}

		repaint();
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
		super.paintComponent(graphics);
        Graphics2D graphics2D = (Graphics2D) graphics;

        final int width = getWidth();
        final int height = getHeight();
        graphics2D.setColor(Color.DARK_GRAY);
        graphics2D.fillRect(0, 0, width, height);

        graphics2D.setStroke( new BasicStroke(3) );
        for ( int i = 0; i < RECTANGLE_COUNT; i++ ) {
        	graphics2D.setColor(( i < changeCount ) ? currentColor : previousColor);
        	final int size = ( height / 2 ) + ( i + 1 - RECTANGLE_COUNT ) * 10;
        	graphics2D.drawRect(size, size, width - 2 * size, height - 2 * size);
        }

        graphics2D.dispose();
	}
	
	private VibratingRectangles() {
		setPreferredSize( new Dimension(400, 300) );
        ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
        executorService.scheduleAtFixedRate(this, 500, 200, TimeUnit.MILLISECONDS);

        previousColor = Color.RED;
        currentColor = Color.CYAN;
	}
	
	private int changeCount;
	private Color previousColor, currentColor;
	private RandomGenerator random = RandomGenerator.getDefault();
	
	private static final int RECTANGLE_COUNT = 15;
	private static final List<Color> COLORS = List.of(
		Color.BLUE, Color.CYAN, Color.GREEN, Color.MAGENTA, Color.ORANGE, Color.PINK, Color.RED, Color.YELLOW ); 	

}

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Point;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.swing.JFrame;
import javax.swing.JPanel;

public final class AnimatedSpinners extends JPanel implements Runnable {

	public static void main(String[] args) {
		EventQueue.invokeLater( () -> {
			JFrame.setDefaultLookAndFeelDecorated(true);
			JFrame frame = new JFrame("Animated Spinners");
			frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);		
			frame.add( new AnimatedSpinners() );
			frame.setLocationByPlatform(true);		
			frame.setResizable(false);
			frame.pack();					
			frame.setVisible(true);				
		} );
	}	
	
	@Override
    public void paintComponent(Graphics graphics) {
    	super.paintComponent(graphics);
    	Graphics2D graphics2D = (Graphics2D) graphics;
        graphics2D.setColor(Color.BLACK);
        graphics2D.fillOval(24, 24, SIZE - 48, SIZE - 48);

        spinners.forEach( s -> s.draw(graphics2D) );
    }
	
	@Override
	public void run() {
		repaint();
	}
	
	private AnimatedSpinners() {
		setPreferredSize( new Dimension(SIZE, SIZE) );
		setBackground(Color.DARK_GRAY);
		setDoubleBuffered(true);
		addMouseMotionListener(Spinner.listener);
		
		spinners = List.of( new Spinner(0, 0, Color.GREEN), new Spinner(-120, -120, Color.RED),
						    new Spinner(120, -120, Color.YELLOW), new Spinner(-120, 120, Color.WHITE),
						    new Spinner(120, 120, Color.ORANGE) );
		
		ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
		executorService.scheduleAtFixedRate(this, 0, 20, TimeUnit.MILLISECONDS);
	}
	
	private static final class Spinner {
		
		public Spinner(int aOffsetX, int aOffsetY, Color aColour) {
			centreX = SIZE / 2 + aOffsetX;
			centreY = SIZE / 2 + aOffsetY;
			colour = aColour;
		}
		
		public void draw(Graphics2D graphics2D) {
			Point delta = mouseMovement();
			centreX += delta.x;
			centreY += delta.y;
			angle = ( angle + ANGLE_INCREMENT ) % TAU;
			final int endX = centreX + (int) ( RADIUS * Math.cos(angle) );
			final int endY = centreY + (int) ( RADIUS * Math.sin(angle) );
			graphics2D.setColor(colour);
			graphics2D.setStroke( new BasicStroke(2.0F) );
			graphics2D.drawLine(centreX, centreY, endX, endY);
		}
		
		private Point mouseMovement() {
			Point delta = new Point(0, 0);
			// Move the spinner left or right with the horizontal mouse  position
	        if ( mouseY > centreY - RADIUS && mouseY < centreY + RADIUS ) {
	            if ( mouseX > centreX && mouseX < centreX + RADIUS ) { delta.x= -10; }
	            if ( mouseX < centreX && mouseX > centreX - RADIUS ) { delta.x = +10; }
	        }
	
			// Move the spinner up or down with the vertical mouse position
	        if ( mouseX > centreX - RADIUS && mouseX < centreX + RADIUS ) {
	            if ( mouseY < centreY && mouseY > centreY - RADIUS ) { delta.y = +10; }
	            if ( mouseY > centreY && mouseY < centreY + RADIUS ) { delta.y = -10; }
	        }
	
	        // Ensure that the spinner remains in the black background circle
	        return ( Math.hypot(SIZE / 2 - centreX, SIZE / 2 - centreY) < SIZE / 2 - RADIUS - 24 - 10) ?
	            delta : new Point(0, 0);
		}		
		
		private int centreX, centreY;	
		
		private final Color colour;
		
		private static double angle;
		private static int mouseX, mouseY;
		
		private static final int RADIUS = 60;
		private static final double ANGLE_INCREMENT = Math.PI / 6.0;
		private static final double TAU = 2 * Math.PI;			
		private static final MouseAdapter listener = new MouseAdapter() {
		
			public void mouseMoved(MouseEvent event) {
                mouseX = event.getX();
                mouseY = event.getY();
            }
			
		};	
				
	}

	private List<Spinner> spinners;
	
	private static final int SIZE = 600;

}

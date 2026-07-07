import module java.base;
import module java.desktop;

public final class LorenzAttractor extends JComponent implements Runnable {

	public static void main() {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Lorenz Attractor");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);
            frame.add( new LorenzAttractor() );
            frame.pack();
            frame.setLocationByPlatform(true);
            frame.setVisible(true);
        } );
	}
	
	@Override
	public void run() {
		final double timeFactor = 0.01;
		
		x += ( SIGMA * ( y - x ) ) * timeFactor;
		y += ( x * ( RHO - z ) - y ) * timeFactor;
		z += ( x * y - BETA * z ) * timeFactor;

	    // Scale point to screen size
	    points.addLast( new Point2D.Double(x * 10, y * 10) );

	    // Memory protection: a maximum of 2,000 points are stored to avoid stuttering
	    if ( points.size() > 2_000 ) {
	        points.removeFirst();
	    }
	
	    repaint();
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
        super.paintComponent(graphics);
        Graphics2D graphics2D = (Graphics2D) graphics;

        final int width = getWidth();
        final int height = getHeight();

        graphics2D.setColor(Color.BLACK);
        graphics2D.fillRect(0, 0, width, height);
        graphics2D.translate(width / 2, height / 2);
        graphics2D.setColor(Color.MAGENTA);

        // Draw lines between all the points stored so far
        IntStream.range(0, points.size() - 1).forEach( i -> {
             graphics2D.draw( new Line2D.Double(points.get(i), points.get(i + 1)) );
        } );

        graphics2D.dispose();
	}	
	
	private LorenzAttractor() {
		setPreferredSize( new Dimension(800, 600) );
        ScheduledExecutorService service = Executors.newSingleThreadScheduledExecutor();
        service.scheduleAtFixedRate(this, 0, 40, TimeUnit.MILLISECONDS);
	}
	
	// Starting position
	private double x = 0.01, y = 0.0, z = 0.0;
	
	// List of points to draw
	private AbstractList<Point2D.Double> points = new LinkedList<Point2D.Double>();
	
	// Mathematical parameters of the Lorenz attractor
	private static final double SIGMA = 10.0;
	private static final double RHO = 28.0;
	private static final double BETA = 8.0 / 3.0;

}

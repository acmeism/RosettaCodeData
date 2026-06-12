import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.Shape;
import java.awt.geom.Ellipse2D;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class SolarSystemModel extends JComponent implements Runnable {

	public static void main() {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Solar System Model");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);
            frame.add( new SolarSystemModel() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
	}
	
	@Override
	public void run() {
		for ( CelestialBody body : celestialBodies ) {
			angularPositions.compute(body, (k, v) -> ( v + body.anglularStep ) % 360.0);	
		}
		
		repaint();
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
        super.paintComponent(graphics);
        Graphics2D graphics2D = (Graphics2D) graphics;
        graphics2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        graphics2D.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);

        final int width = getWidth();
        final int height = getHeight();

        graphics2D.setColor(Color.DARK_GRAY);
        graphics2D.fillRect(0, 0, width, height);

        Font font = new Font("Courier New", Font.PLAIN, 14);
        graphics2D.setFont(font);
        FontMetrics metrics = getFontMetrics(font);
        int indent = 50;
        for ( CelestialBody body : celestialBodies ) {
        	graphics2D.setPaint(body.color);
        	graphics2D.drawString(body.name, indent, 20);
        	indent += 20 + metrics.stringWidth(body.name);
        }

        graphics2D.translate(width / 2, height / 2);

        Point viewPoint = createViewPoint(View.HELIOCENTRIC);
        for ( CelestialBody body : celestialBodies ) {
        	Point position = ( body == moon ) ? moonPosition(viewPoint) : planetPosition(body, viewPoint);
        	graphics2D.setPaint(body.color);
        	graphics2D.fill(createCircle(position, body.radius));
        }

        graphics2D.dispose();
	}
	
	private SolarSystemModel() {
        setPreferredSize( new Dimension(600, 600) );
        setBackground(Color.DARK_GRAY);
        ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
        executorService.scheduleAtFixedRate(this, 0, 150, TimeUnit.MILLISECONDS);
    }
	
	private static Point moonPosition(Point viewPoint) {
	    Point point = planetPosition(earth, viewPoint);
	    final double angle = Math.toRadians(angularPositions.get(moon));
	    final double orbitRadius = moon.orbitalRadius;
	    return new Point(point.x + orbitRadius * Math.cos(angle), point.y + orbitRadius * Math.sin(angle));
	}
	
	private static Point planetPosition(CelestialBody body, Point viewPoint) {
	    final double angle = Math.toRadians(angularPositions.get(body));
	    final double orbitRadius = body.orbitalRadius;
	    return new Point(orbitRadius * Math.cos(angle) + viewPoint.x, orbitRadius * Math.sin(angle) + viewPoint.y);
	}
	
	private static Point createViewPoint(View view) {
		return switch ( view ) {
			case GEOCENTRIC -> {
				Point sunPosition = planetPosition(sun, new Point(0.0, 0.0));
				Point earthPosition = planetPosition(earth, new Point(0.0, 0.0));
				yield new Point(sunPosition.x - earthPosition.x, sunPosition.y - earthPosition.y);				
			}
		  	case HELIOCENTRIC -> new Point(0.0, 0.0);
		};
	}
	
	private static Shape createCircle(Point position, double radius) {
		return new Ellipse2D.Double(position.x - radius, position.y - radius, 2.0 * radius, 2.0 * radius);
	}
	
	private static enum View { GEOCENTRIC, HELIOCENTRIC }
	
	private static record Point(double x, double y) {}
	
	private static record CelestialBody(
		String name, int radius, int orbitalRadius, double anglularStep, Color color) {}
	
	private static CelestialBody sun = new CelestialBody("Sun", 7, 0, 0.0, Color.YELLOW);
	private static CelestialBody mercury = new CelestialBody("Mercury", 3, 24, 49.0, Color.PINK);	
	private static CelestialBody venus = new CelestialBody("Venus", 4, 48, 19.0, Color.LIGHT_GRAY);
	private static CelestialBody earth = new CelestialBody("Earth", 4, 72, 11.86, Color.GREEN);
	private static CelestialBody moon = new CelestialBody("Moon", 1, 8, 36, Color.WHITE);
	private static CelestialBody mars = new CelestialBody("Mars", 3, 96, 6.3, Color.RED);
	private static CelestialBody jupiter = new CelestialBody("Jupiter", 5, 120, 1.0, Color.ORANGE);
	private static CelestialBody saturn = new CelestialBody("Saturn", 4, 160, 0.3, Color.MAGENTA);
	
	private static List<CelestialBody> celestialBodies =
		List.of( sun, mercury, venus, earth, moon, mars, jupiter, saturn );
	
	private static Map<CelestialBody, Double> angularPositions =
		celestialBodies.stream().collect(Collectors.toMap(k -> k, v -> 0.0));	

}

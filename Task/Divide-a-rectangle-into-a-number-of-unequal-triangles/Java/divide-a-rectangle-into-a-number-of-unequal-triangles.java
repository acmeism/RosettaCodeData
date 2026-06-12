import java.awt.Color;
import java.awt.Dimension;
import java.awt.EventQueue;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Path2D;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

import javax.swing.JComponent;
import javax.swing.JFrame;

public final class DivideARectangleIntoANumberOfTriangles extends JComponent {

	public static void main(String[] args) {
		EventQueue.invokeLater( () -> {
        	JFrame.setDefaultLookAndFeelDecorated(true);
            JFrame frame = new JFrame("Divide a rectangle into a number of triangles");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setResizable(false);
            frame.add( new DivideARectangleIntoANumberOfTriangles() );
            frame.pack();
            frame.setLocationRelativeTo(null);
            frame.setVisible(true);
        } );
	}
	
	@Override
	protected void paintComponent(Graphics graphics) {
        super.paintComponent(graphics);
        Graphics2D graphics2D = (Graphics2D) graphics;

        List<Color> colours = List.of( Color.RED, Color.GREEN, Color.BLUE );
        IntStream.range(0, triangles.size()).forEach( i -> {
        	graphics2D.setColor(colours.get(i % colours.size()));
        	graphics2D.fill(triangles.get(i));        	
        } );
	}
	
	private DivideARectangleIntoANumberOfTriangles() {
		setPreferredSize( new Dimension(400, 300) );
		triangles = divideRectangle(400, 300, 8);
	}
	
	private List<Triangle> divideRectangle(float width, float height, int triangleCount) {
		if ( triangleCount < 3 ) {
			throw new AssertionError("Cannot divide rectangle into less than three triangles.");
		}
		
		System.out.println("Dividing the rectangle "
			+ "[(0, 0), (" + width + ", 0), (" + width + ", " + height + "), (0, " + height + ")]"
			+ " into " + triangleCount + " triangles: ");
		
		final Point origin = new Point(0.0f, 0.0f);
	    float sideLength = width / ( triangleCount - 1 );
	    float firstSideLength = sideLength; // Length of the edge for the leftmost lower triangle.

	    // Ensure that the leftmost lower triangle is not similar to the first triangle. As 'firstSideLength < width',
	    // this would be the case if 'firstSideLength' is such that 'width / height = height / firstSideLength'.
	    if ( width * firstSideLength == height * height ) {
	    	firstSideLength += 1.0;
	    	sideLength = ( width - firstSideLength ) / ( triangleCount - 2 );
	    }

	    List<Triangle> triangles = new ArrayList<Triangle>();
	    // Add the leftmost lower triangle.
	    Triangle triangle = new Triangle(origin, new Point(firstSideLength, height), new Point(0.0f, height));
	    triangles.add(triangle);
	    System.out.println(triangle);
	
	    // Add the remaining lower triangles except for the rightmost one to allow for rounding errors.
	    float x = firstSideLength;
	    for ( int i = 0; i < triangleCount - 3; i++ ) {
	    	final float nextX = x + sideLength;
	    	triangle = new Triangle(origin, new Point(nextX, height), new Point(x, height));
	    	triangles.add(triangle);
		    System.out.println(triangle);
	    	x = nextX;
	    }

	    // Add the rightmost lower triangle.
	    triangle = new Triangle(origin, new Point(width, height), new Point(x, height));
    	triangles.add(triangle);
	    System.out.println(triangle);

	    // Finally, add the upper triangle.
	    triangle = new Triangle(origin, new Point(width, 0.0f), new Point(width, height));
    	triangles.add(triangle);
	    System.out.println(triangle);

	    return triangles;
	}
	
	private record Point(float x, float y) {
		
		public String toString() {
			return "(" + x + ", " + y + ")";
		}
		
	}
	
	private static final class Triangle extends Path2D.Float {
		
		public Triangle(Point aOne, Point aTwo, Point aThree) {
			one = aOne; two = aTwo; three = aThree;
			
			moveTo(one.x, one.y);
		    lineTo(two.x, two.y);
		    lineTo(three.x, three.y);
		    closePath();
		}
		
		public String toString() {
			return "[" + one + ", " + two + ", " + three + "]";
		}
		
		private Point one, two, three;
				
	}
	
	private List<Triangle> triangles;

}

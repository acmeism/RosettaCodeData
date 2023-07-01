import java.awt.Point;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public final class SierpinskiArrowhead {

	public static void main(String[] aArgs) throws IOException {
		List<Point> points = initialStraightLine();
    	for ( int i = 1; i < 8; i++ ) {
    		points = nextIteration(points);
    	}    	
    	
    	String text = sierpinskiArrowheadText(points, IMAGE_SIZE);
    	Files.write(Paths.get("sierpinkskiArrowhead.svg"), text.getBytes());
	}
	
	private static List<Point> initialStraightLine() {
		final int margin = 50;
	    final int boxSize = IMAGE_SIZE - 2 * margin;
	    final int x = margin;
	    final int y = Math.round(( IMAGE_SIZE + SQRT3_2 * boxSize ) / 2.0F);
	
	    List<Point> points = Arrays.asList( new Point(x, y), new Point(x + boxSize, y) );
	    return points;
	}
	
	private static List<Point> nextIteration(List<Point> aPoints) {
		List<Point> result = new ArrayList<Point>();
		
	    for ( int i = 0; i < aPoints.size() - 1; i++ ) {
	        final int x0 = aPoints.get(i).x;
	        final int y0 = aPoints.get(i).y;
	        final int x1 = aPoints.get(i + 1).x;
	        final int y1 = aPoints.get(i + 1).y;
	        final int dx = x1 - x0;
	        result.add( new Point(x0, y0) );
	
	        if ( y0 == y1 ) {
	            final float d = Math.abs(dx) * SQRT3_2 / 2;
	            result.add( new Point(x0 + dx / 4, Math.round(y0 - d)) );
	            result.add( new Point(x1 - dx / 4, Math.round(y0 - d)) );
	        } else if ( y1 < y0 ) {
	        	result.add( new Point(x1, y0));
	        	result.add( new Point(x1 + dx / 2, ( y0 + y1 ) / 2) );
	        } else {
	        	result.add( new Point(x0 - dx / 2, ( y0 + y1 ) / 2) );
	        	result.add( new Point(x0, y1) );
	        }
	    }
	
	    result.add(aPoints.get(aPoints.size() - 1));
	    return result;
	}
	
	private static String sierpinskiArrowheadText(List<Point> aPoints, int aSize) {
    	StringBuilder text = new StringBuilder();    	
    	text.append("<svg xmlns='http://www.w3.org/2000/svg'");
        text.append(" width='" + aSize + "' height='" + aSize + "'>\n");
        text.append("<rect width='100%' height='100%' fill='white'/>\n");
        text.append("<path stroke-width='1' stroke='black' fill='white' d='");
        for ( int i = 0; i < aPoints.size(); i++ ) {
        	text.append(( i == 0 ? "M" : "L" ) + aPoints.get(i).x + ", " + aPoints.get(i).y + " ");
        }
        text.append("'/>\n</svg>\n");
            	
        return text.toString();
    }
	
	private static final float SQRT3_2 = (float) Math.sqrt(3.0F) / 2.0F;
	private static final int IMAGE_SIZE = 700;

}

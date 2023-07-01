import java.awt.Point;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

public final class KochCurve {
	
    public static void main(String[] aArgs) throws IOException {    	
    	List<Point> points = initialEquilateralTriangle();
    	for ( int i = 1; i < 5; i++ ) {
    		points = nextIteration(points);
    	}    	
    	
    	String text = kochCurveText(points, IMAGE_SIZE);
    	Files.write(Paths.get("C:/Users/psnow/Desktop/koch.svg"), text.getBytes());
    }

    private static List<Point> initialEquilateralTriangle() {
    	final int margin = 50;
    	final int boxSize = IMAGE_SIZE - margin;
    	final int sideLength = Math.round(boxSize * SIN_60_DEGREES);
    	final int x = ( boxSize + margin - sideLength ) / 2;
    	final int y = Math.round(( boxSize + margin ) / 2 - sideLength * SIN_60_DEGREES / 3);
    	
    	List<Point> points = Arrays.asList(
                new Point(x, y),
                new Point(x + sideLength / 2, Math.round(y + sideLength * SIN_60_DEGREES)),
                new Point(x + sideLength, y),
                new Point(x, y)
            );
    	
    	return points;    	
    }

    private static List<Point> nextIteration(List<Point> aPoints) {
        List<Point> result = new ArrayList<Point>();

        for ( int i = 0; i < aPoints.size() - 1; i++ ) {
        	final int x0 = aPoints.get(i).x;
            final int y0 = aPoints.get(i).y;
            final int x1 = aPoints.get(i + 1).x;
            final int y1 = aPoints.get(i + 1).y;
            final int dy = y1 - y0;
            final int dx = x1 - x0;

            result.add(aPoints.get(i));
            result.add( new Point(x0 + dx / 3, y0 + dy / 3) );
            result.add( new Point(Math.round(x0 + dx / 2 - dy * SIN_60_DEGREES / 3),
            					  Math.round(y0 + dy / 2 + dx * SIN_60_DEGREES / 3)) );
            result.add( new Point(x0 + 2 * dx / 3, y0 + 2 * dy / 3) ) ;
        }

        result.add(aPoints.get(aPoints.size() - 1));
        return result;
    }

    private static String kochCurveText(List<Point> aPoints, int aSize) {
    	StringBuilder text = new StringBuilder();
        text.append("<svg xmlns='http://www.w3.org/2000/svg'");
        text.append(" width='" + aSize + "' height='" + aSize + "'>\n");
        text.append("<rect style='width:100%;height:100%;fill:cyan'/>\n");
        text.append("<polygon points='");
        for ( int i = 0; i < aPoints.size(); i++ ) {
            text.append(aPoints.get(i).x + ", " + aPoints.get(i).y + " ");
        }
        text.append("' style='fill:pink;stroke:black;stroke-width:2'/>\n</svg>\n");

        return text.toString();
    }

    private static final int IMAGE_SIZE = 700;
    private static final float SIN_60_DEGREES = (float) Math.sin(Math.PI / 3.0);

}
